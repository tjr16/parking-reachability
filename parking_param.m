%% This file contains parameters for reachability.
% For each parking task, we gotta initialize parameters again.

%% 
if strcmp(MODE, "parallel")
    CLOCKWISE = true;  % parking spot +90/-90 with respect to marker CZ
elseif strcmp(MODE, "parallel-anti")  % anti-clockwise
    CLOCKWISE = false;
else
    clear CLOCKWISE;
end
rSpot = 0.1;  % radius of the initial region of reference point
rInflate = WIDTH/2;  % How much we inflate obstacles.
% We can tune rInflate if not feasible!

% marker pose: (CX, CY, CZ)
% spot center：(SX, SY, SZ)

% SX = CX + (0.1+WIDTH/2) * cos(CZ); SY = CY + (0.1+WIDTH/2) * sin(CY);
% GRID_MIN = [SX-2; SY-2; -pi; -1]; % Lower corner of computation domain
% GRID_MAX = [SX+2; SY+2; pi; 1];
% lSpot = [SX-0.2; SY-0.2; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
% uSpot = [SX+0.2; SY+0.2; meanTheta + stdTheta; maxV];

%%
if strcmp(MODE, 'forward')
    SX = CX + (0.1+WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1+WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    GRID_MIN = [SX-2; SY-2; -pi; -1]; % Lower corner of computation domain
    GRID_MAX = [SX+2; SY+2; pi; 1];
    % lower and upper bounds of the parking spot
%     GRID_MIN = [-1; -1; -pi; -1]; % Lower corner of computation domain
%     GRID_MAX = [1; 1; pi; 1];
    meanTheta = SZ;
    stdTheta = pi/10;
%     minV = 0;
%     maxV = 0.2;
    goodV = 0;
%     goodV = (minV+maxV)/2;  % the velocity which we wanna project 4D plot to
%     lSpot = [-0.2; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.2; 0.3; meanTheta + stdTheta; maxV];
%     lSpot = [-0.17; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.17; 0.15; meanTheta + stdTheta; maxV];
    % lower and upper bounds of obstacles
    % in sequence: left obs; right obs; center obs
    %       [center]
    % [left][ spot ][right]
    % [xmin, ymin, theta_min, vmin]
    % [xmax, ymax, theta_max, vmax]

elseif strcmp(MODE, 'reverse')
    SX = CX + (0.1-WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1-WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    GRID_MIN = [SX-2; SY-2; -pi; -1]; % Lower corner of computation domain
    GRID_MAX = [SX+2; SY+2; pi; 1];
%     GRID_MIN = [-1; -1; -pi; -1]; % Lower corner of computation domain
%     GRID_MAX = [1; 1; pi; 1];
    % lower and upper bounds of the parking spot
    meanTheta = SZ;
    stdTheta = pi/10;
    goodV = 0;
%     minV = -0.2;
%     maxV = 0;
%     goodV = (minV+maxV)/2;  % the velocity which we wanna project 4D plot to
%     lSpot = [-0.2; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.2; 0.2; meanTheta + stdTheta; maxV];
%     lSpot = [-0.17; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.17; 0.15; meanTheta + stdTheta; maxV];
    % lower and upper bounds of obstacles
    % in sequence: left obs; right obs; center obs
    %       [center]
    % [left][ spot ][right]
    % [xmin, ymin, theta_min, vmin]
    % [xmax, ymax, theta_max, vmax]

elseif strcmp(MODE, 'parallel') || strcmp(MODE, 'parallel-anti')   
    if CLOCKWISE
        SZ = CZ - pi/2;
    else
        SZ = CZ + pi/2;
    end
%     SX = CX + (0.1+SDEPTH/2) * cos(CZ) - WHEELBASE/2 * cos(SZ);
%     SY = CY + (0.1+SDEPTH/2) * sin(CZ) - WHEELBASE/2 * sin(SZ);

    % Now it is + instead of - because we simulate forward parking
    % but finally we go backward
    SX = CX + (0.1+SDEPTH/2) * cos(CZ) + WHEELBASE/2 * cos(SZ);
    SY = CY + (0.1+SDEPTH/2) * sin(CZ) + WHEELBASE/2 * sin(SZ);

    GRID_MIN = [SX-2; SY-2; -pi; -1]; % Lower corner of computation domain
    GRID_MAX = [SX+2; SY+2; pi; 1];
%     GRID_MIN = [-1; -1; -pi; -1]; % Lower corner of computation domain
%     GRID_MAX = [1; 1; pi; 1];
    % lower and upper bounds of the parking spot
    meanTheta = SZ;
    stdTheta = pi/10;
    goodV = 0;
%     minV = -0.2;
%     maxV = 0.2;
%     goodV = (minV+maxV)/2;  % the velocity which we wanna project 4D plot to
%     lSpot = [-0.2; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.2; 0.3; meanTheta + stdTheta; maxV];
%     lSpot = [-0.17; 0; meanTheta - stdTheta; minV];  % lSpot = [-0.17; -0.15; -pi/24; -1];
%     uSpot = [0.17; 0.15; meanTheta + stdTheta; maxV];
    % lower and upper bounds of obstacles
    % in sequence: left obs; right obs; center obs
    %       [center]
    % [left][ spot ][right]
    % [xmin, ymin, theta_min, vmin]
    % [xmax, ymax, theta_max, vmax]
end


