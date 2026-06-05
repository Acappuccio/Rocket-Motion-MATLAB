function [Thrust] = rocketthrust(current)
    if isfield(current, 'FT') && isa(current.FT, 'function_handle')
        % If FT field is present and is a valid function handle
        % Call the rocketmotion function to determine the trajectory
        rocketmotion(current);
        
        % Calculate thrust based on the rocket motion (replace with actual calculation)
        % Example: Thrust is a function of velocity, altitude, etc.
        Thrust = current.FT(current);
    else
        % If FT is not present or not a valid function handle
        Thrust = 20000; % Default thrust value
    end
end
