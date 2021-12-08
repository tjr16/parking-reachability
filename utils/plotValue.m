function [value, theta, reach] = plotValue(data, grid_min, grid_max, listN)
% 3Dplot value function
% assume grid has the same size on x, y direction
    
    N = listN(1);
    nTheta = listN(3);
    minG = grid_min(1);
    maxG = grid_max(1);
    minTheta = grid_min(3);
    maxTheta = grid_max(3);
    
    flipData = flip(data, 5);  % time from beginning
    initData = flipData(:, :, :, :, 1);  % first time step
    staticData = initData(:, :, :, floor(size(initData,4)/2));
    [value, argmin] = min(staticData,[], 3);
    argminIdx = ind2sub(size(staticData),argmin);
    theta = minTheta + argminIdx/nTheta * (maxTheta-minTheta);
    
    valueT = value';  % transposed
    thetaT = theta';
    % [argval, argmin] = min(initData, [], [3,4]);

    delta = (maxG-minG)/(N-1);
    [X,Y] = meshgrid(minG:delta:maxG);
%     d_theta = (maxTheta-minTheta)/(nTheta-1);
%     [X1,Y1]=meshgrid(minTheta:d_theta:maxTheta);
    figure;
    surf(X, Y, valueT);
    xlabel('X');
    ylabel('Y');
    figure;
    surf(X, Y, thetaT);
    xlabel('X');
    ylabel('Y');
    zlabel('theta');
    
    reach = double(value<0);
    reachT = reach';
    figure;
    surf(X, Y, reachT);
    xlabel('X');
    ylabel('Y');

end
