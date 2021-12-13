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
goodV = 0;  % project to this velocity
if strcmp(MODE, 'forward')
    SX = CX + (0.1+WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1+WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];
    meanTheta = SZ;
    stdTheta = pi/10;

elseif strcmp(MODE, 'reverse')
    SX = CX + (0.1-WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1-WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];
    meanTheta = SZ;
    stdTheta = pi/10;

elseif strcmp(MODE, 'parallel') || strcmp(MODE, 'parallel-anti')   
    if CLOCKWISE
        SZ = CZ - pi/2;
    else
        SZ = CZ + pi/2;
    end
    % Now it is + instead of - because we simulate forward parking
    % but finally we go backward
    SX = CX + (0.1+SDEPTH/2) * cos(CZ) + WHEELBASE/2 * cos(SZ);
    SY = CY + (0.1+SDEPTH/2) * sin(CZ) + WHEELBASE/2 * sin(SZ);
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];
    meanTheta = SZ;
    stdTheta = pi/10;
end


