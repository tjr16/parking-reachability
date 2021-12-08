function dx = dynamics(obj, ~, x, u, d)
% Dynamics of the Dubins Car
%    \dot{x}_1 = v * cos(x_3) + d1
%    \dot{x}_2 = v * sin(x_3) + d2
%    \dot{x}_3 = (v/L) * tan(u_1) + d2
%    \dot{x}_4 = a
%            a = ...   
%   Control: u = w;
%
% Mo Chen, 2016-06-08

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
  
%   dx(1) = obj.speed * cos(x(3)) + d(1);
%   dx(2) = obj.speed * sin(x(3)) + d(2);
%   dx(3) = u + d(3);
  % dx(3) = (obj.speed/L) * tan(u) + d(3)
  
  dx(1) = x(4) * cos(x(3)) + d(1);
  dx(2) = x(4) * sin(x(3)) + d(2);
  dx(3) = (x(4)/obj.L)*tan(u(1)) + d(3);
%   dx(4) = (u(2) - x(4)) / obj.t * obj.dt + d(4);
  dx(4) = u(2) + d(4);
end
end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)
% this is used in simulation.
switch dim
  case 1
    dx = x{dims==4} .* cos(x{dims==3}) + d{1};
  case 2
    dx = x{dims==4} .* sin(x{dims==3}) + d{2};
  case 3
    dx = (x{dims==4}./obj.L).*tan(u{dims==1}) + d{3};
    %dx = u + d{3};
  case 4
%     dx = (u{dims==2}-x{dims==4})/obj.t*obj.dt + d{4};
  dx = u{dims==2} + d{4};
        
  otherwise
    error('Only dimension 1-3 are defined for dynamics of DubinsCar!')
end
end