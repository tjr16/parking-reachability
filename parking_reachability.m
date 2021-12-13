%% Reachability analysis starts here.

%% Grid
grid_min = GRID_MIN;
grid_max = GRID_MAX;    
N = [25; 25; 25; 10];

pdDims = 3;               % 3rd dimension is periodic
g = createGrid(grid_min, grid_max, N, pdDims);

%% Collect all obstacles in the map
allObs = cat(2, currentObs, mapObs);
numObs = numel(allObs);
obstacles = cell(numObs, 1);

%% Parking spot and obstacles
% set parking spot and init obstacles
parkingSpot = shapeCylinder(g, [3, 4], [SX; SY; 0; 0], rSpot);
for i = 1:numObs
    obstacles{i} = arbitraryObstacle(g, allObs{i}, rInflate);
end

%% System parameters
max_acc = 1;
max_steering = 28/180*pi; % radians: 28 deg in path planner

vel_x_disturb = 0.01; % m/s
vel_y_disturb = 0.01; % m/s
steer_actuation_disturb = pi/100; % radians
velocity_actuation_disturbance = 0.01; % m/s
disturbances = [vel_x_disturb, vel_y_disturb, steer_actuation_disturb, velocity_actuation_disturbance];

%% Pack problem parameters
dCar = Team1Car_v2([0, 0, 0, 0], max_steering, max_acc, disturbances);
% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = dCar;
schemeData.accuracy = 'high';
% uMode: forward reachability 'max'; backward reachability: 'min'
schemeData.uMode = 'min';
HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = 1; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update

%% Compute union of obstacles
if ADD_OBSTACLE
    allObstacles = cat(1, obstacles{:});
    baseObstacle = allObstacles{1}; % temp variable, saving obstacles
    for i = 2:numel(allObstacles)
        baseObstacle = min(baseObstacle, allObstacles{i});
    end

    HJIextraArgs.obstacleFunction = baseObstacle; % add the union of obstacles
end

HJIextraArgs.visualize.xTitle = 'x [m]';
HJIextraArgs.visualize.yTitle = 'y [m]';
HJIextraArgs.visualize.zTitle = '$\theta$ [rad]';
axis equal;

if PLOT2D
    % plot x, y, and not theta or velocity
    HJIextraArgs.visualize.plotData.plotDims = [1 1 0 0]; 
    % MODIFY THIS LINE -- project at [theta(rad), velocity]
    HJIextraArgs.visualize.plotData.projpt = [meanTheta goodV];
    % plot marker and spot
    t = linspace(0, 2*pi);
    r = 0.1;
    x = SX + r*cos(t);
    y = SY + r*sin(t);
    r = 0.05;
    x1 = CX + r*cos(t);
    y1 = CY + r*sin(t);
    patch(x, y, 'r')
    patch(x1, y1, 'b');
    
    HJIextraArgs.visualize.holdOn = true;
    xlabel("x"); ylabel("y");
elseif PLOT4D
    % DO NOTHING
else % 3D
    % plot x, y, and not theta or velocity
    HJIextraArgs.visualize.plotData.plotDims = [1 1 1 0]; 
    % MODIFY THIS LINE -- project at [theta(rad), velocity]
    HJIextraArgs.visualize.plotData.projpt = goodV;
    xlabel("x"); ylabel("y"); zlabel('$\theta$','interpreter','latex');
end

% TODO: try changing out 'none' for 'minVOverTime'
% figure(100);
[data, tau2, ~] = ...
  HJIPDE_solve(parkingSpot, tau, schemeData, 'minVOverTime', HJIextraArgs);

%% patch: vehicle rectangle
lLarge = (LENGTH+WHEELBASE)/2;
lSmall = (LENGTH-WHEELBASE)/2;
if strcmp(MODE, 'forward')  % forward, parallel
    SZ1 = SZ - pi/2;
    SZ2 = SZ + pi/2;
    vX = [SX + lLarge * cos(SZ) + WIDTH/2 * cos(SZ1), ...
        SX + lLarge * cos(SZ) + WIDTH/2 * cos(SZ2), ...
        SX - lSmall * cos(SZ) + WIDTH/2 * cos(SZ1), ...
        SX - lSmall * cos(SZ) + WIDTH/2 * cos(SZ2)];

    vY = [SY + lLarge * sin(SZ) + WIDTH/2 * sin(SZ1), ...
        SY + lLarge * sin(SZ) + WIDTH/2 * sin(SZ2), ...
        SY - lSmall * sin(SZ) + WIDTH/2 * sin(SZ1), ...
        SY - lSmall * sin(SZ) + WIDTH/2 * sin(SZ2)];
else  % parallel or reverse
    % Because we do forward parking to simulate these cases.
    revSZ = SZ + pi;  % This is true 'SZ'
    revSZ1 = revSZ - pi/2;
    revSZ2 = revSZ + pi/2;
    vX = [SX + lLarge * cos(revSZ) + WIDTH/2 * cos(revSZ1), ...
        SX + lLarge * cos(revSZ) + WIDTH/2 * cos(revSZ2), ...
        SX - lSmall * cos(revSZ) + WIDTH/2 * cos(revSZ1), ...
        SX - lSmall * cos(revSZ) + WIDTH/2 * cos(revSZ2)];

    vY = [SY + lLarge * sin(revSZ) + WIDTH/2 * sin(revSZ1), ...
        SY + lLarge * sin(revSZ) + WIDTH/2 * sin(revSZ2), ...
        SY - lSmall * sin(revSZ) + WIDTH/2 * sin(revSZ1), ...
        SY - lSmall * sin(revSZ) + WIDTH/2 * sin(revSZ2)];
end

hullIdx = convhull(vX, vY);
patch(vX(hullIdx),vY(hullIdx), 'm', 'faceAlpha', 0.3); 
