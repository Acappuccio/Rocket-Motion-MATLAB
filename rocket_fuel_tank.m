% Parameters
rho = 70.85; % density of liquid hydrogen in kg/m^3
g = 9.81; % acceleration due to gravity in m/s^2
y_start = 0; % lower limit of y
y_end = 10; % upper limit of y (height of the cone)
R = 2; % radius at the base of the cone

% Function definition for radius
f = @(y) R * (1 - y/y_end); % r = f(y)

% Volume Calculation
volume_integral = @(y) pi * (f(y)).^2; 
V = integral(volume_integral, y_start, y_end);

% Work Calculation
A = @(y) pi * (f(y)).^2; % Area function
D = @(y) y_end - y; % Distance to pump

% Work integral
work_integral = @(y) rho * g * A(y) .* D(y);
W = integral(work_integral, y_start, y_end);

% Display Results
fprintf('Volume of the tank: %.2f m^3\n', V);
fprintf('Work to pump the liquid out: %.2f J\n', W);

% Create a new figure
figure;

% Define the cone parameters
n = 50;  % Number of points around the base
r = linspace(2, 0, 2);  % Radius vector: [2 0] for a cone
h = [0 10];  % Height vector: [0 10] for height

% Generate the cylinder (cone) coordinates
[X, Y, Z] = cylinder(r, n);
Z = Z * (h(2) - h(1)) + h(1);  % Adjust Z to match desired height

% Create the surface plot (outer surface of the cone)
h_surf = surf(X, Y, Z, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'none');

hold on;

% Create the base of the cone using patch
t = linspace(0, 2*pi, n);
x_base = r(1) * cos(t);
y_base = r(1) * sin(t);
h_base = patch(x_base, y_base, zeros(size(t)), [0.3 0.3 0.3]);
set(h_base, 'EdgeColor', 'none');

% Add concentric circles to the base
num_circles = 5;
for i = 1:num_circles
    radius = r(1) * i / num_circles;
    x_circle = radius * cos(t);
    y_circle = radius * sin(t);
    plot(x_circle, y_circle, 'k', 'LineWidth', 0.5);
end

% Add black outline to the base
plot(x_base, y_base, 'k', 'LineWidth', 2);

% Add 3D grid
grid_size = 3;  % Adjust this value to change grid density
grid_spacing = 1;  % Adjust this value to change the spacing between grid lines

% X-Y plane grids at different Z levels
for z = 0:grid_spacing:h(2)
    [X_grid, Y_grid] = meshgrid(-grid_size:grid_spacing:grid_size);
    Z_grid = z * ones(size(X_grid));
    plot3(X_grid, Y_grid, Z_grid, 'Color', [0.7 0.7 0.7], 'LineStyle', ':');
end

% X-Z plane grids at different Y levels
for y = -grid_size:grid_spacing:grid_size
    [X_grid, Z_grid] = meshgrid(-grid_size:grid_spacing:grid_size, 0:grid_spacing:h(2));
    Y_grid = y * ones(size(X_grid));
    plot3(X_grid, Y_grid, Z_grid, 'Color', [0.7 0.7 0.7], 'LineStyle', ':');
end

% Y-Z plane grids at different X levels
for x = -grid_size:grid_spacing:grid_size
    [Y_grid, Z_grid] = meshgrid(-grid_size:grid_spacing:grid_size, 0:grid_spacing:h(2));
    X_grid = x * ones(size(Y_grid));
    plot3(X_grid, Y_grid, Z_grid, 'Color', [0.7 0.7 0.7], 'LineStyle', ':');
end

% Label axes and set title
xlabel('x');
ylabel('y');
zlabel('z');
title('Rocket Fuel Tank');

% Set axis properties
axis equal;
box on;

% Adjust axis limits for a tighter view
axis([-grid_size grid_size -grid_size grid_size 0 h(2)]);

% Set the view for a better 3D perspective
view(30, 30);

% Add lighting for better 3D effect
light('Position', [1 1 1], 'Style', 'infinite');
light('Position', [-1 -1 2], 'Style', 'infinite');

% Set lighting algorithm
lighting gouraud;

% Ensure proper rendering order
set(h_surf, 'FaceAlpha', 0.99);
set(h_base, 'FaceAlpha', 1);

% Display volume and work
text(-grid_size*0.9, -grid_size*0.9, h(2), sprintf('Volume: %.2f m^3', 41.89), 'FontSize', 10);
text(-grid_size*0.9, -grid_size*0.9, h(2)*0.9, sprintf('Work: %.2f J', 218352.78), 'FontSize', 10);

hold off;