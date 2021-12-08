function pList = interPoints(p1, p2, nInter, radius)
%   Interpolate between two 2D points.
% Param:
%   p1 = [x1, y1]; p2 = [x2, y2]; 
%   nInter is #points after interpolation

if nargin < 4
    radius = 0.05;
end

if (nargin < 3) || isempty(nInter) 
    euclid = sqrt(sum((p2-p1).^2));
    nInter = ceil(euclid/radius);
%     nInter = 8;
end
x = [p1(1), p2(1)]; 
y = [p1(2), p2(2)];
 
x_inter = p1(1):(p2(1)-p1(1))/(nInter-1):p2(1);
y_inter = interp1(x, y, x_inter);
pList = [x_inter; y_inter];
% size: (2, nInter). So each column is one point.
% eg. get the first point by: pList(:, 1)

end
