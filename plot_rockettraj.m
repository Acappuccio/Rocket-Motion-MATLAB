function [state_history] = plot_rockettraj(current,dt,T);
    % Initialize the rocket state
    current = struct('t', 0, 'h', 0, 'v', 0, 'm', 50000, 'g', 9.8, 'rho0', 1);

    % Time step
    dt = 1;

    % Total time
    total_time = 40;

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
            fprintf('Time: %d seconds\n', total_time);
            fprintf('Height: %.2f meters\n', next.h);
            fprintf('Velocity: %.2f m/s\n', next.v);
            fprintf('Mass: %.2f kg\n', next.m);
            fprintf('Gravity: %.2f m/s^2\n', next.g);
            fprintf('-------------------------\n');
        end
    end
end

