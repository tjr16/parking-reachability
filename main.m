
%% Main script

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
% map_obst = ReadYaml(mapPath);

map_obst = {};
run('obs_tf.m');  
% NOTE: return ps, type, marker, spot_dim
% ps: each element is a parking spot, including several obstacles.

%% Feasibility
[possible_task, possible_task_idx] = ...
    feasibilityTest(parking_spots, LENGTH, WIDTH);

%% Add another case for parking
nTask = numel(ps);  % #tasks
for i = 1:nTask
%     if type{i} == "parallel"
    ps{end+1} = ps{i};
    type{end+1} = strcat(type{i}, "-anti"); %parallel-anti";
    marker{end+1} = marker{i};
    spot_dim{end+1} = spot_dim{i};
    nTask = nTask + 1;
    possible_task_idx(end+1) = nTask;
end
nTask = numel(ps);

%% Reachability
xSpot = {};  % x: spot
ySpot = {};  % y: spot
zSpot = {};  % z: spot
yawReach ={};  % yaw: starting point
typeSpot = {}; % type: spot
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
        if startsWith(MODE, 'forward')
            yawReach{end+1} = meanTheta;
            zSpot{end+1} = SZ;
        else
            yawReach{end+1} = meanTheta + pi;  % real 'SZ' for reverse/parallel
            zSpot{end+1} = SZ + pi;
        end
        typeSpot{end+1} = MODE;
%         hold on;
    end
end

%% Save a figure
timeStr = string(datetime('now'));
saveStr = sprintf('fullMap %s.fig', erase(timeStr, ':'));
fileStr = sprintf('data %s.txt', erase(timeStr, ':'));
savefig(saveStr);

%% Print info and write info into file
fid = fopen(fileStr, 'w');
for i = 1:numel(xSpot)
    % yaw: end point
    yawSpot = zSpot{i};
    yawSpot = wrapToPi(yawSpot);
    fprintf("%s parking spot located at (%f, %f, %f) \n", typeSpot{i}, xSpot{i}, ySpot{i}, yawSpot);
    fprintf(fid, "%s parking spot located at (%f, %f, %f) \n", typeSpot{i}, xSpot{i}, ySpot{i}, yawSpot);
    % yaw: start point
    yawR = yawReach{i};
    yawR = wrapToPi(yawR);
    fprintf("\t corresponding yaw angle: %f (pick your (x,y) by yourself!) \n", yawR); 
    fprintf(fid, "\t corresponding yaw angle: %f (pick your (x,y) by yourself!) \n", yawR); 
end
fclose(fid);
