function transform = tfGenerator(theta, trans)
    % This func generates a `rigid2d` object.
    % Helper function of tfToOrigin.
    %
    % Input: theta (yaw), trans ([x, y])
    % Return: transform (rigid2d)
    % 
    % How to use transform:
    %   >> transform.transformPointsForward([0, 0])
    %   ans = [2 3];
    %   Note the input of transformPointsForward should be N x 2.
    %
    % J is responsible for this file.

    rot = [ cosd(theta) sind(theta); ...
           -sind(theta) cosd(theta)];
    transform = rigid2d(rot,trans);

end