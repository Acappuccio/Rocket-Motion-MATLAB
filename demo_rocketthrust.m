function demo_rocketthrust()

    % Initialize the rocket state
    current = struct('t', 0, 'h', 0, 'v', 0, 'm', 50000, 'g', 9.8, 'rho0', 1, 'm_fuel', 40000);

    % Time step
    dt = 0.1;

    % Total time
    total_time = 50;

    % Number of steps
    num_steps = total_time / dt;

    % Initialize arrays to store the state at each time step
    state_history = cell(1, num_steps);
    thrust_history = zeros(1, num_steps);
    position_history = zeros(1, num_steps);

    % Loop over each time step
    for i = 1:num_steps
        % Call the rocketmotion function
        next = rocketmotion(current, dt);

        % Store the state
        state_history{i} = next;

        % Store thrust and position at each time step
        thrust_history(i) = next.T;
        position_history(i) = next.h;

        % Update the current state
        current = next;

        % Print the state at each second
        if mod(i, 10) == 0
            fprintf('Time: %d seconds\n', i/1);
            fprintf('Height: %.2f meters\n', next.h);
            fprintf('Velocity: %.2f m/s\n', next.v);
            fprintf('Mass: %.2f kg\n', next.m);
            fprintf('Gravity: %.2f m/s^2\n', next.g);
            fprintf('Thrust: %.2f N\n', next.T);
            fprintf('-------------------------\n');
        end
    end

    % Extract the data from the state_history
    time = cellfun(@(state) state.t, state_history);

    % Create a new figure
    figure;

    % Plot thrust vs position with a continuous line
    plot(position_history, thrust_history, '-');
    title('Thrust vs Position');
    xlabel('Position (m)');
    ylabel('Thrust (N)');
    grid on;
end
