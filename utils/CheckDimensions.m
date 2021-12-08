function [width,length] = CheckDimensions(parking_type, spot_dim)
% Extracts the dimensions of the parking spot
%   The variable names represents different properties depending on the
%   park
if isequal(parking_type,'parallel')
    width = spot_dim.depth;
    length = spot_dim.width;
else
    width  = spot_dim.width;
    length = spot_dim.depth;
    
end

end

