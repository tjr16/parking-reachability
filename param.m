
%% This file contains basic parameters used in the main script.

%% Yaml file paths
taskPath = 'park_task.yaml';
mapPath = 'obstacles.yaml';
% Parking mode
% MODES = {'forward', 'backward', 'parallel'};
% MODE = MODES{1};  % select mode

%% Plot mode: 2D or 3D?
PLOT_MODE = '2d';  % '2d' or '3d', otherwise it'll be 4d.
if strcmp(PLOT_MODE, '2d')
    PLOT2D = true; PLOT4D = false;
elseif strcmp(PLOT_MODE, '3d')
    PLOT2D = false; PLOT4D = false;
else  % otherwise, plot4d
    PLOT2D = false; PLOT4D = true;
end

% PLOT2D = false;  % 2D has higher priority
% PLOT4D = false;

%% Time vector
t0 = 0; tMax = 2; dt = 0.1;
tau = t0:dt:tMax;

%% Obstacles
ADD_OBSTACLE = true;
INFLATE = false;  % only implemented for rectangles

%% Vehicle parameters
% Consider these parameters. How can we inflate the obstacles?
WIDTH = 0.249;
LENGTH = 0.586;
WHEELBASE = 0.324;
% MAX_DIST = sqrt(WIDTH^2 + LENGTH^2);

%% Save data for value function plot
% saveData = {}; 
% saveGridMin = {}; 
% saveGridMax = {};

%% Obstacles: left, right, center blocks of the parking spot
% TODO: import real obstacles instead of these (defined by us).
% lObs = [[-0.5; 0; -Inf; -Inf], ...
%     [0.4; 0; -Inf; -Inf], ...
%     [-0.5; 0.3; -Inf; -Inf]
%     ];%, [-.5; 0.3; -pi; -Inf]];
% uObs = [[-0.4; 0.3; Inf; Inf], ...
%     [0.5; 0.3; Inf; Inf], ...
%     [0.5; 0.6; Inf; Inf]
%     ];%, [0.5; 0.6; pi; Inf]];
