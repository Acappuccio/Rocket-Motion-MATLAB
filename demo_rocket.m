function demo_rocket()

    % Initialize the rocket state
    current = struct('t', 0, 'h', 0, 'v', 0, 'm', 50000, 'g', 9.8, 'rho0', 1, 'm_fuel', 40000);

    % Time step
    dt = 1;

    % Total time
    total_time = 60;

    % Number of steps
    num_steps = total_time / dt;

    % Initialize array to store the state at each time step
    state_history = cell(1, num_steps);

    % Loop over each time step
    for i = 1:num_steps
        % Call the rocketmotion function
        next = rocketmotion(current, dt);

        % Store the state
        state_history{i} = next;

        % Update the current state
        current = next;

        % Print the state at each second
        if mod(i, 10) == 0
            fprintf('Time: %d seconds\n', i/1);
            fprintf('Height: %.2f meters\n', next.h);
            fprintf('Velocity: %.2f m/s\n', next.v);
            fprintf('Mass: %.2f kg\n', next.m);
            fprintf('Gravity: %.2f m/s^2\n', next.g);
            fprintf('-------------------------\n');
        end
    end

    % Extract the data from the state_history
    time = cellfun(@(state) state.t, state_history);
    velocity = cellfun(@(state) state.v, state_history);
    position = cellfun(@(state) state.h, state_history);
    mass = cellfun(@(state) state.m, state_history);

    % Create a new figure
    figure;
% Plot velocity vs time
subplot(3,1,1);
plot(time, velocity);
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
ylim([min(0) max(200)]); % Set the limits for velocity

% Plot position vs time
subplot(3,1,2);
plot(time, position);
title('Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
ylim([min(0) max(1500)]); % Set the limits for position

% Plot mass vs time
subplot(3,1,3);
plot(time, mass);
title('Mass vs Time');
xlabel('Time (s)');
ylabel('Mass (kg)');
ylim([min(mass) max(50500)]); % Set the limits for mass

end

