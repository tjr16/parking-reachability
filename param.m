
%% This file contains basic parameters used in the main script.

%% Yaml file paths
taskPath = 'park_task.yaml';
mapPath = 'obstacles.yaml';

%% Plot mode: 2D or 3D?
PLOT_MODE = '2d';  % '2d' or '3d', otherwise it'll be 4d.
if strcmp(PLOT_MODE, '2d')
    PLOT2D = true; PLOT4D = false;
elseif strcmp(PLOT_MODE, '3d')
    PLOT2D = false; PLOT4D = false;
else  % otherwise, plot4d
    PLOT2D = false; PLOT4D = true;
end

%% Time vector
t0 = 0; tMax = 2; dt = 0.1;
tau = t0:dt:tMax;

%% Obstacles
ADD_OBSTACLE = true;
INFLATE = false;  % only implemented for rectangles

%% Vehicle parameters
WIDTH = 0.249;
LENGTH = 0.586;
WHEELBASE = 0.324;
