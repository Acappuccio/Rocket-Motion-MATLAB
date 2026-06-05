% Example of using rocketthrust function

% Create a sample current structure
current = struct('h', 1000, 'v', 200, 't', 10, 'FT', @customThrustFunction);

% Call the rocketthrust function to calculate thrust
Thrust = rocketthrust(current);

% Display the calculated thrust
fprintf('Calculated Thrust: %.2f Newtons\n', Thrust);

% Example of a custom thrust function
function thrust = customThrustFunction(current)
    % This is just an example; replace with your actual thrust calculation
    % The thrust may depend on altitude, velocity, time, or other parameters.
    % For simplicity, this example uses a linear combination of altitude and velocity.
    thrust = 5000 + 10 * current.h + 0.1 * current.v;
end
