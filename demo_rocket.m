function demo_rocket()

    % ── Rocket Parameters (edit these) ──────────────────
    dry_mass       = 5000;    % kg  (rocket body without fuel)
    fuel_mass      = 45000;   % kg  (starting fuel)
    thrust_max     = 600000;  % N   (max thrust force)
    Isp            = 453;     % s   (specific impulse / engine efficiency)
    drag_coeff     = 0.5;     % dimensionless drag coefficient
    rocket_area    = 1.0;     % m^2 (cross-sectional area)
    launch_angle   = 85;      % degrees from horizontal (90 = straight up)

    % ── Staging (set stage2_start = total_time to disable) ──
    stage2_start   = 40;      % s   (time at which first stage drops)
    stage1_mass    = 8000;    % kg  (mass of first stage hardware dropped)

    % ── Simulation Settings ─────────────────────────────
    dt             = 0.5;     % s   (time step - smaller = more accurate)
    total_time     = 120;     % s   (total simulation time)
    % ────────────────────────────────────────────────────

    % Initialize state
    current.t            = 0;
    current.x            = 0;
    current.h            = 0;
    current.vx           = 0;
    current.v            = 0;
    current.m            = dry_mass + fuel_mass;
    current.dry_m        = dry_mass;
    current.g            = 9.8;
    current.mach         = 0;
    current.staged       = false;
    current.Isp          = Isp;
    current.Cd           = drag_coeff;
    current.A            = rocket_area;
    current.thrust_max   = thrust_max;
    current.angle        = launch_angle;
    current.stage2_start = stage2_start;
    current.stage1_mass  = stage1_mass;
    current.T            = 0;

    num_steps     = round(total_time / dt);
    state_history = cell(1, num_steps);

    for i = 1:num_steps
        next            = rocketmotion(current, dt);
        state_history{i} = next;
        current         = next;

        % Stop simulation if rocket hits the ground after launch
        if next.h < 0 && i > 1
            state_history = state_history(1:i);
            break;
        end
    end

    % ── Extract history ──────────────────────────────────
    time     = cellfun(@(s) s.t,    state_history);
    velocity = cellfun(@(s) s.v,    state_history);
    altitude = cellfun(@(s) s.h,    state_history);
    mass     = cellfun(@(s) s.m,    state_history);
    mach     = cellfun(@(s) s.mach, state_history);
    horiz    = cellfun(@(s) s.x,    state_history);

    % ── Summary Stats ────────────────────────────────────
    [max_alt,  idx_alt]  = max(altitude);
    [max_vel,  idx_vel]  = max(velocity);
    [max_mach, idx_mach] = max(mach);

    fprintf('\n========== FLIGHT SUMMARY ==========\n');
    fprintf('Max Altitude  : %.2f m (%.2f km) at t=%.1fs\n', max_alt,  max_alt/1000,  time(idx_alt));
    fprintf('Max Velocity  : %.2f m/s at t=%.1fs\n',          max_vel,  time(idx_vel));
    fprintf('Max Mach      : %.3f at t=%.1fs\n',              max_mach, time(idx_mach));
    fprintf('Burnout Mass  : %.2f kg\n',                       mass(end));
    fprintf('Horiz Distance: %.2f m (%.2f km)\n',              horiz(end), horiz(end)/1000);
    if max_mach >= 1
        idx_sonic = find(mach >= 1, 1);
        fprintf('Went Supersonic at t=%.1fs\n', time(idx_sonic));
    end
    fprintf('=====================================\n\n');

    % ── Plots ────────────────────────────────────────────
    figure('Name', 'Rocket Flight Data', 'NumberTitle', 'off');

    subplot(3,2,1);
    plot(time, velocity, 'b', 'LineWidth', 1.5);
    title('Vertical Velocity vs Time');
    xlabel('Time (s)'); ylabel('Velocity (m/s)');
    grid on;

    subplot(3,2,2);
    plot(time, altitude / 1000, 'r', 'LineWidth', 1.5);
    title('Altitude vs Time');
    xlabel('Time (s)'); ylabel('Altitude (km)');
    grid on;

    subplot(3,2,3);
    plot(time, mass, 'g', 'LineWidth', 1.5);
    title('Mass vs Time');
    xlabel('Time (s)'); ylabel('Mass (kg)');
    grid on;

    subplot(3,2,4);
    plot(time, mach, 'm', 'LineWidth', 1.5);
    yline(1, '--k', 'Mach 1');
    title('Mach Number vs Time');
    xlabel('Time (s)'); ylabel('Mach Number');
    grid on;

    subplot(3,2,[5 6]);
    plot(horiz / 1000, altitude / 1000, 'k', 'LineWidth', 1.5);
    title('2D Trajectory (Downrange vs Altitude)');
    xlabel('Downrange Distance (km)'); ylabel('Altitude (km)');
    grid on;

end
