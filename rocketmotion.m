function [next] = rocketmotion(current, dt)

    % Constants
    g0 = 9.8; % Standard gravity (m/s^2)
    R = 287.05; % Specific gas constant for dry air (J/(kg·K))
    T0 = 288.15; % Standard temperature at sea level (K)
    L = 0.0065; % Temperature lapse rate (K/m)
    rho0 = 1; % Sea level air density (kg/m^3)
    Isp = 453; % Specific impulse (in seconds)
    u = Isp * g0; % Effective exhaust velocity

    % Air density (varying with altitude)
    h = current.h; % Current altitude (meters)
    T = T0 - L * h; % Temperature at altitude h
    rho = rho0 * (T / T0).^(g0 / (R * L)); % Density at altitude h

    % Other parameters (unchanged from original code)
    A = 1.0;
    weight = current.m * g0; % Gravity acts downward

    % Variable thrust (adjust as needed)
    max_mass_flow_rate = 100;
    max_velocity = 1000; % Maximum velocity at which throttle is at max

    % Decrease throttle linearly with velocity
    throttle = max(0, 1 - current.v / (max_velocity + 0.01)); % Added a small constant to prevent throttle from becoming zero

    mass_flow_rate = max(0, max_mass_flow_rate * throttle);

    % Calculate thrust with a decrease with altitude
    thrust = mass_flow_rate * Isp * g0;

    % Update state
    next = current;
    next.t = current.t + dt;
    next.m = current.m - mass_flow_rate * dt;

    % Calculate drag after updating velocity
    drag = 0.5 * rho * A * next.v.^2;

    % Calculate Coriolis force (example, you may need to adjust based on your scenario)
    omega = 7.2921159e-5; % Earth's angular speed (rad/s)
    F_coriolis = 2 * current.v * omega * sin(current.h);

    % Sum of forces (considering thrust, drag, and Coriolis force)
    sumF = weight - thrust - drag - F_coriolis; % Subtract thrust because it acts in the opposite direction of weight

    % Acceleration
    next.acc = (sumF / current.m);

    % Calculate new velocity and height
    next.v = (current.v + next.acc * dt);
    next.h = current.h + (current.v + next.v) / 2 * dt; % Use the average velocity to calculate the new height
    % Calculate the change in gravity
    next.g = g0 - (0.00029 * next.h);

    % Store the calculated thrust in the next structure
    next.T = thrust;
end
