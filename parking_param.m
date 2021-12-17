%% This file contains parameters for reachability.
% For each parking task, we gotta initialize parameters again.

%% 
if endsWith(MODE, "anti")  % anti-clockwise
    CLOCKWISE = false; 
else
    CLOCKWISE = true; % parking spot +90/-90 with respect to marker CZ
end
rSpot = 0.05;  % radius of the initial region of reference point
stdTheta = pi/10;
rInflate = WIDTH;  % How much we inflate obstacles.
% We can tune rInflate if not feasible!

% marker pose: (CX, CY, CZ)
% spot center：(SX, SY, SZ)
goodV = 0;  % project to this velocity
if startsWith(MODE, 'forward') 
    SX = CX + (0.1+WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1+WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    SZ = wrapToPi(SZ);
    if CLOCKWISE
        meanTheta = SZ - pi/2;  % starting point: 
    else
        meanTheta = SZ + pi/2;
    end
    meanTheta = wrapToPi(meanTheta);
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];

elseif startsWith(MODE, 'reverse') 
    SX = CX + (0.1-WHEELBASE/2+SDEPTH/2) * cos(CZ);
    SY = CY + (0.1-WHEELBASE/2+SDEPTH/2) * sin(CZ);
    SZ = CZ + pi;
    SZ = wrapToPi(SZ);
    if CLOCKWISE
        meanTheta = SZ - pi/2;
    else
        meanTheta = SZ + pi/2;
    end
    meanTheta = wrapToPi(meanTheta);
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];

elseif startsWith(MODE, 'parallel') 
    if CLOCKWISE
        SZ = CZ - pi/2;
    else
        SZ = CZ + pi/2;
    end
    SZ = wrapToPi(SZ);  % very important!
    % Now it is + instead of - because we simulate forward parking
    % but finally we go backward
    SX = CX + (0.1+SDEPTH/2) * cos(CZ) + WHEELBASE/2 * cos(SZ);
    SY = CY + (0.1+SDEPTH/2) * sin(CZ) + WHEELBASE/2 * sin(SZ);
    GRID_MIN = [SX-2; SY-2; -pi; -1];
    GRID_MAX = [SX+2; SY+2; pi; 1];
    meanTheta = SZ;
end


