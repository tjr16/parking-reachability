%% ======= Declaration =======
% This is the 3rd version of the main script.
% 1) yaml file reading
% 2) feasibility check
% 3) reachability analysis
% ==============================

%% Preparation
clear
warning('off');
% add utility functions
addpath('utils');
% add example data
addpath('data');
% import parameters
run('param.m');

%% Read yaml file
parking_spots = ReadYaml(taskPath);  % class: 'struct'
map_obst = ReadYaml(mapPath);
run('obs_tf.m');  
% NOTE: return ps, type, marker, spot_dim
% ps: each element is a parking spot, including several obstacles.
%   Get a spot:
%   >> ps{1}f
%   Get an obs: (size: 2 x n)
%   >> ps{1}{1}
% type: 
%   >> type{1}
% marker: each element is a struct {x, y, yaw}
%   >> marker{1}.x
% spot_dim: struct{width, depth}
%   >> spot_dim{1}.width
% allPs = cat(2, ps{:});

%% Feasibility
[possible_task, possible_task_idx] = ...
    feasibilityTest(parking_spots, LENGTH, WIDTH);

% possible_type = type{possible_task_idx};

%% Add more tasks for parallel cases
nTask = numel(ps);  % #tasks
for i = 1:nTask
    if type{i} == "parallel"
        ps{end+1} = ps{i};
        type{end+1} = "parallel-anti";
        marker{end+1} = marker{i};
        spot_dim{end+1} = spot_dim{i};
        nTask = nTask + 1;
        possible_task_idx(end+1) = nTask;
    end
end
nTask = numel(ps);

%% Save info
xSpot = {};
ySpot = {};
yawReach ={};
typeSpot = {};

%% Reachability
for i = 1:nTask
    % each time we process one task if it's feasible
    % finally all tasks are plotted in the same figure
    if ismember(i, possible_task_idx)  % feasible?
        MODE = type{i};           % get mode
        fprintf('Current parking mode: %s\n', MODE);
        currentObs = ps{i};       % get obstacles
        currentMark = marker{i};  % get marker
        % CX, CY, CZ: Aruco marker pose
        CX = currentMark.x; CY = currentMark.y; CZ = currentMark.yaw;
        drawUnitVec(CX, CY, CZ);  % plot marker pose as an arrow
        % SWIDTH, SDEPTH: parking spot's size
        SWIDTH = spot_dim{i}.width; SDEPTH = spot_dim{i}.depth;
        run('parking_param.m');
        run('parking_reachability');
        xSpot{end+1} = SX;
        ySpot{end+1} = SY;
        yawReach{end+1} = SZ;
        typeSpot{end+1} = MODE;
    end
end

%% TODO: plot value function
% save a figure; then read it again (make a copy)
timeStr = string(datetime('now'));
saveStr = sprintf('fullMap %s.fig', erase(timeStr, ':'));
savefig(saveStr);
openfig(saveStr);

%% Print info
for i = 1:numel(xSpot)
    fprintf("%s parking spot (%f, %f) \n", typeSpot{i}, xSpot{i}, ySpot{i});
    fprintf("corresponding yaw angle: %f \n", yawReach{i}); 
end

