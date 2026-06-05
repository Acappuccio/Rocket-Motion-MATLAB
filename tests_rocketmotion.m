function tests_rocketmotion()
#Trivial test 
% Define the initial state
current = struct();
current.t = 0; % time
current.m = 1000; % mass
current.v = 0; % velocity
current.h = 0; % height
current.acc = 0; % acceleration
current.g = 9.8; % gravity
current.T = 0; % thrust
% Define the time step
dt = 0.1;

% Call the function
next = rocketmotion(current, dt);

% Check the results
assert(next.t == current.t + dt, 'Time not updated correctly');
assert(next.m < current.m, 'Mass not decreased');
assert(next.g >= current.g, 'Gravity not decreased');
assert(next.T >= current.T, 'Thrust not increased');
fprintf('Trivial tests passed.\n');
%Precision test 
% Define a tolerance

% Define initial conditions
current.t = 0;
current.m = 50000;
current.v = 0;
current.h = 0;
current.g = 9.8;
current.T = 0;
current.acc = 0; % acceleration
dt = 1;

% Call the function
next = rocketmotion(current, dt);

% Define expected results (replace with actual expected results)
expected_next.t = 1;
expected_next.m = 49900;
expected_next.v = 0.9212;
expected_next.h = 0.4606;
expected_next.g = 9.799866;
expected_next.T = 443940;
expected_next.acc = .9212;
% Compare each field in the structures
fields = fieldnames(next);
for i = 1:numel(fields)
    diff = abs(next.(fields{i}) - expected_next.(fields{i}));
    assert(diff < 1e-5, 'Field %s is not within tolerance: diff = %g', fields{i}, diff);
end

fprintf('Precision tests passed.\n');
% Symmetry test 
% Define the initial state
current = struct();
current.t = 10; % time
current.m = 49900.04; % massTime: 10 seconds
current.v = 0.92; % velocity
current.h = 0.46; % height
current.g = 9.8; % gravity
current.T = 443126.89; % thrust
current.acc = 1;
% Define the time step
dt = 1;
% Call the function to go forward in time
next = rocketmotion(current, dt);

% Now use 'next' as the current state and run the function backwards in time
previous = rocketmotion(next, -dt);

% Define a tolerance
tol = 1e-1;
% Compare each field in the structures
fields = fieldnames(previous);
for i = 1:numel(fields)
    diff = abs(previous.(fields{i}) - current.(fields{i}));
    assert(diff < tol, 'Field %s is not within tolerance: diff = %g', fields{i}, diff);
end

fprintf('Symmetry test passed.\n');
end















