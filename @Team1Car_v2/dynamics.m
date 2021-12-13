function dx = dynamics(obj, ~, x, u, d)
% Dynamic of our car
%    \dot{x}_1 = v * cos(x_3) + d1
%    \dot{x}_2 = v * sin(x_3) + d2
%    \dot{x}_3 = (v/L) * tan(u_1) + d2
%    \dot{x}_4 = a
%            a = ...   
%   Control: u = [delta, acc];
%

if nargin < 5
  d = [0; 0; 0; 0];
end

if iscell(x)
  dx = cell(length(obj.dims), 1);
  for i = 1:length(obj.dims)
    dx{i} = dynamics_cell_helper(obj, x, u, d, obj.dims, obj.dims(i));
  end
else
  dx = zeros(obj.nx, 1);
  
  dx(1) = x(4) * cos(x(3)) + d(1);
  dx(2) = x(4) * sin(x(3)) + d(2);
  dx(3) = (x(4)/obj.L)*tan(u(1)) + d(3);
  dx(4) = u(2) + d(4);
end
end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)
% This is actually used in our simulation.
    switch dim
      case 1
        dx = x{dims==4} .* cos(x{dims==3}) + d{1};
      case 2
        dx = x{dims==4} .* sin(x{dims==3}) + d{2};
      case 3
        dx = (x{dims==4}./obj.L).*tan(u{dims==1}) + d{3};
      case 4
      dx = u{dims==2} + d{4};

      otherwise
        error('Only dimension 1-4 are defined for dynamics of Team1Car_v2!')
    end
end