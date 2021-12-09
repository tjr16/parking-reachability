%% Reachability analysis starts here.

%% Grid
grid_min = GRID_MIN;
grid_max = GRID_MAX;
% grid_min = [-1; -1; -pi; -1]; % Lower corner of computation domain
% grid_max = [1; 1; pi; 1];    % Upper corner of computation domain
% Number of grid points per dimension
% N = [10; 10; 30; 10];
% N = [30; 30; 20; 20];
% N = [21; 21; 31; 10];       
N = [25; 25; 25; 10];

pdDims = 3;               % 3rd dimension is periodic
g = createGrid(grid_min, grid_max, N, pdDims);

% the grid above is a 3D box that goes from [-2, 2] meters in x, [-2, 2]
% meters in y, and [-pi, pi] radians in heading. We also specify that
% dimension 3 (theta/heading) is periodic, so it wraps around from -pi to
% pi and vice versa.

%% obs_cell: for drawing obstacles around parking spots in 2D figures
% obs_cell = cell(size(lObs,2), 1);
% numObs = length(obs_cell);
% for i = 1:numObs
%     obs_cell{i} = [lObs(1:2, i); uObs(1:2, i)];
% end

%% Collect all obstacles in the map
allObs = cat(2, currentObs, mapObs);
numObs = numel(allObs);
obstacles = cell(numObs, 1);

%% Parking spot and obstacles
% set parking spot and init obstacles
% TODO: define skew parking spots
% parkingSpot = shapeRectangleByCorners(g, lSpot, uSpot);
parkingSpot = shapeCylinder(g, [3, 4], [SX; SY; 0; 0], rSpot);
for i = 1:numObs
    obstacles{i} = arbitraryObstacle(g, allObs{i}, rInflate);
end

% shapeRectangleByCorners creates an N-dimensional rectangle based on the
% minimum corner and maximum corner you give. The dimension of this
% rectangle needs to correspond to the dimension of the controlled sytem.

%% Add other obstacles

% How to add arbitrary obstacles? See testPoints.
% testPoints = [[-0.5;-0.6] [-0.7;-0.8] [-0.4; -0.95] [-0.3; -0.9] [0; -0.7]];
% obs1 = arbitraryObstacle(g, testPoints, 0.05);
% for i = 1: length(obs1)
%     obstacles{end+1} = obs1(i);
% end

% obstacles{end+1} = {shapeRectangleByCorners(...
%         g, [-0.1; -0.3; -inf; -inf], ...
%         [0.1; -0.1; inf; inf])};

% obs_cell{end+1} = [0, -0.2, 0, -0.2];
% obstacles{end+1} = {inflatedRectangle(g, obs_cell{end}, radius)};
% 
% obstacles{end+1} = {shapeRectangleByCorners(...
%         g, [-0.5; -0.6; -inf; -inf], ...
%         [-0.2; -0.25; inf; inf])};

% obstacles{end+1} = {shapeRectangleByCorners(...
%         g, [-0.5; -0.6; -inf; -inf], ...
%         [-0.2; -0.25; inf; inf])};

% points = [[-0.5, -0.7];[-0.7, -0.5]];
% points_inter = interPoints(points(1,:), points(2,:));
% for i = 1:size(points_inter, 2)
%     obstacles{end+1} = {shapeCylinder(g, [3, 4], [points(1, i); lObs(2, i); 0; 0], 0.05)};
% end
%     

% obs_cell{end+1} = [-0.3, -0.3, -0.3, -0.3];
% obstacles{end+1} = {inflatedRectangle(g, obs_cell{end}, radius)};
% obs_cell{end+1} = [0, -0.2, 0, -0.2];
% obstacles{end+1} = {inflatedRectangle(g, obs_cell{end}, radius)};

%% System parameters

%TODO: play with all of these! Recommended you do one by one though.

% max_velocity = 1; % m/s
max_acc = 1;
max_steering = pi/4; % radians

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
schemeData.accuracy = 'high'; % set accuracy
% uMode: forward reachability 'max'; backward reachability: 'min'
schemeData.uMode = 'min';

%% additive random noise

%TODO: try uncommenting this out and playing with adding gaussian noise to
%      your states

%HJIextraArgs.addGaussianNoiseStandardDeviation = [0.05; 0.05; 0.1];

% You can also consider other noise coefficients, like:
%    [0.2,0,0;0,0.2,0;0,0,0.5]; % Independent noise on all states
%    [0.2;0.2;0.5]; % Coupled noise on all states
%    {zeros(size(g.xs{1})); zeros(size(g.xs{1})); (g.xs{1}+g.xs{2})/20}; % State-dependent noise

%% Compute value function

% HJIextraArgs.visualize = true; %show plot
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

%     if INFLATE
%         for i = 1:length(inflateObs)
%             baseObstacle = min(baseObstacle, cell2mat(inflateObs(i)));
%         end
%     end
    HJIextraArgs.obstacleFunction = baseObstacle; % add the union of obstacles
end

HJIextraArgs.visualize.xTitle = 'x [m]';
HJIextraArgs.visualize.yTitle = 'y [m]';
HJIextraArgs.visualize.zTitle = '$\theta$ [rad]';
axis equal;

if PLOT2D
    %TODO: comment out the two lines below to see 3D view
    %TODO: try changing the projection point for the 2D view to another value
    % plot x, y, and not theta or velocity
    HJIextraArgs.visualize.plotData.plotDims = [1 1 0 0]; 
    % MODIFY THIS LINE -- project at [theta(rad), velocity]
    HJIextraArgs.visualize.plotData.projpt = [meanTheta goodV];
    
    % plot obstacles and parking spot; hold on
%     plotRectangle([lSpot(1), lSpot(2), uSpot(1), uSpot(2)], true);
%     plotRectangle(obs_cell);
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
%     goodTheta = 0;
    HJIextraArgs.visualize.plotData.projpt = goodV;
%     HJIextraArgs.visualize.plotData.projpt = meanTheta;
    xlabel("x"); ylabel("y"); zlabel('$\theta$','interpreter','latex');
end

% TODO: try changing out 'none' for 'minVOverTime'
% figure(100);
[data, tau2, ~] = ...
  HJIPDE_solve(parkingSpot, tau, schemeData, 'minVOverTime', HJIextraArgs);

%% patch: vehicle rectangle
lLarge = (LENGTH+WHEELBASE)/2;
lSmall = (LENGTH-WHEELBASE)/2;
if ~strcmp(MODE, 'reverse')
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
else
    revSZ = SZ + pi;
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

% save('save_data.mat', 'data');
%% Save data for plot
% TODO: initialize these cells
% saveData{end+1} = data;
% saveGridMin{end+1} = GRID_MIN;
% saveGridMax{end+1} = GRID_MAX;
% Assume we use the same N

% not good
% val = plotValueMap(data, grid_min, grid_max, N);

% if false
%     [val, theta, reach] = plotValue(data, GRID_MIN, GRID_MAX, N);
% %     val = flipdim(value, 1);
% end
