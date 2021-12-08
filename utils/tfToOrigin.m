function transform = tfToOrigin(coord)
    % This func generates a `rigid2d` object. By this rigid transform
    % we can create a frame the origin of which is (0, 0, 0).
    %
    % Input: coord [x, y, yaw]
    %   It's the coordinate of the parking spot in world frame!
    % Return: transform (rigid2d)
    % 
    % Example:
    %   >> transform = tfToOrigin(coord)
    %   >> transform.transformPointsInverse([-2 -2])
    %   ans = 
    %       [-1.4142 0];
    %   We do worldFrame coordinates -> spotFrame.
    %   Note the input of transformPointsForward should be N x 2.
    %
    % J is responsible for this file.

    if iscolumn(coord)
        coord = coord';
    end
    
    theta = coord(3);
    trans = coord(1:2);
    % get transform to a new frame origin of which is (0,0,0) 
    transform = tfGenerator(theta, trans);

end