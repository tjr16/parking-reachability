function drawUnitVec (x1, y1, yaw)
    drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 );    
    x2 = x1 + cos(yaw);
    y2 = y1 + sin(yaw);
    x = [x1 x2];
    y = [y1 y2];
    drawArrow(x,y)
end