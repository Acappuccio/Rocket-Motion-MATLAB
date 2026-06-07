function [next] = rocketmotion(current, dt)

    % ── Constants ────────────────────────────────────────
    g0    = 9.8;        % Standard gravity at sea level (m/s^2)
    R_air = 287.05;     % Specific gas constant for dry air (J/kg·K)
    T0    = 288.15;     % Sea level temperature (K)
    L     = 0.0065;     % Temperature lapse rate (K/m)
    rho0  = 1.225;      % Sea level air density (kg/m^3)
    R_e   = 6371000;    % Earth radius (m)
    lat   = 28.5;       % Launch latitude in degrees (e.g. Kennedy Space Center)
    omega = 7.2921e-5;  % Earth angular velocity (rad/s)

    % ── Unpack config from state ─────────────────────────
    h           = current.h;
    v           = current.v;
    vx          = current.vx;
    m           = current.m;
    dry_m       = current.dry_m;
    Isp         = current.Isp;
    Cd          = current.Cd;
    A           = current.A;
    thrust_max  = current.thrust_max;
    angle_deg   = current.angle;
    stage2_t    = current.stage2_start;
    stage1_m    = current.stage1_mass;
    staged      = current.staged;

    angle_rad   = angle_deg * pi / 180;

    % ── Atmosphere ───────────────────────────────────────
    T   = max(T0 - L * h, 216.65);              % Temperature at altitude (K), floor at stratosphere
    rho = rho0 * (T / T0)^(g0 / (R_air * L));  % Air density at altitude
    a   = sqrt(1.4 * R_air * T);                % Speed of sound (m/s)

    % ── Variable gravity ─────────────────────────────────
    g = g0 * (R_e / (R_e + h))^2;

    % ── Staging ──────────────────────────────────────────
    if ~staged && current.t >= stage2_t
        m      = m - stage1_m;   % Drop first stage hardware
        staged = true;
        fprintf('** Stage separation at t=%.1fs | New mass: %.0f kg **\n', current.t, m);
    end

    % ── Thrust (zero if out of fuel) ─────────────────────
    fuel_remaining = m - dry_m;
    u              = Isp * g0;                            % Exhaust velocity
    max_flow       = thrust_max / u;                      % Max mass flow rate (kg/s)

    % Throttle decreases as velocity increases (same logic as original)
    max_v_throttle = 1000;
    throttle       = max(0, 1 - v / (max_v_throttle + 0.01));
    mass_flow      = max_flow * throttle;

    if fuel_remaining <= 0
        mass_flow = 0;   % No fuel, no thrust
        m         = dry_m;
    end

    thrust = mass_flow * u;

    % ── Drag ─────────────────────────────────────────────
    speed      = sqrt(v^2 + vx^2);                  % Total speed
    drag_total = 0.5 * rho * Cd * A * speed^2;      % Total drag force
    drag_v     = drag_total * (v  / (speed + 1e-9)); % Vertical component
    drag_x     = drag_total * (vx / (speed + 1e-9)); % Horizontal component

    % ── Coriolis force (corrected: uses latitude, not altitude) ──
    F_coriolis = 2 * m * v * omega * sin(lat * pi / 180);

    % ── Forces ───────────────────────────────────────────
    thrust_v = thrust * sin(angle_rad);   % Vertical thrust component
    thrust_x = thrust * cos(angle_rad);   % Horizontal thrust component

    weight   = m * g;

    sum_Fv = thrust_v - weight - drag_v - F_coriolis;
    sum_Fx = thrust_x - drag_x;

    % ── Integrate ────────────────────────────────────────
    acc_v = sum_Fv / m;
    acc_x = sum_Fx / m;

    next_v  = v  + acc_v * dt;
    next_vx = vx + acc_x * dt;

    next_h = h + (v + next_v) / 2 * dt;
    next_x = current.x + (vx + next_vx) / 2 * dt;

    % Floor at ground
    if next_h < 0
        next_h  = 0;
        next_v  = 0;
        next_vx = 0;
    end

    % ── Mach number ──────────────────────────────────────
    mach = speed / a;

    % ── Pack next state ──────────────────────────────────
    next             = current;
    next.t           = current.t + dt;
    next.h           = next_h;
    next.x           = next_x;
    next.v           = next_v;
    next.vx          = next_vx;
    next.m           = m - mass_flow * dt;
    next.g           = g;
    next.mach        = mach;
    next.staged      = staged;
    next.T           = thrust;

end
