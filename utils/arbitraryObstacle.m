function obs = arbitraryObstacle(grid, points, radius)
%   Add an obstacle in arbitrary shape.
% Param:
%   points: 2 X n
%   radius: default 0.05

if nargin < 3
    radius = 0.05;
end

nPoints = size(points, 2);
allPoints = [];
for i = 1:nPoints
    if i < nPoints
        inPoints = interPoints(points(:, i), points(:, i+1), [], radius);
        allPoints = [allPoints inPoints];
    else
        inPoints = interPoints(points(:, i), points(:, 1), [], radius);
        allPoints = [allPoints inPoints];
    end
    % x = [p1(1), p2(1)]; 
% y = [p1(2), p2(2)];

end

nAllPoints = size(allPoints, 2);
obs = cell(nAllPoints, 1);
for j = 1: nAllPoints
    obs{j} = shapeCylinder(grid, [3, 4], [allPoints(1, j); allPoints(2, j); 0; 0], radius);
end
% size: (2, nInter). So each column is one point.
% eg. get the first point by: pList(:, 1)

end

% test
% points = [[-0.1;-0.2] [-0.3;-0.1] [-0.2;0]];
% obs = arbitraryObstacle(g, points);

