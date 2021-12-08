classdef Team1Car_v2 < DynSys
  properties
    % Angle bounds
    wRange
    
    % actually acc range
    vRange
    %speed % Constant speed
    
    % Disturbance
    dRange
    
    % Length of car
    L
    
    t
    
    dt % time step of simulation
    
    % Dimensions that are active
    dims
  end
  
  methods
    function obj = Team1Car_v2(x, wRange, vRange, dRange, L, dims)
      % obj = DubinsCar(x, wMax, speed, dMax, dims)
      %     Dubins Car class
      %
      % Dynamics:
      %    \dot{x}_1 = x(4) * cos(x_3) + d1
      %    \dot{x}_2 = x(4) * sin(x_3) + d2
      %    \dot{x}_3 = x(4) * tan(u(1))*(1/L)
      %    \dot{x}_4 = (u(2)-x(4))/t (acceleration)
      %         u(1) \in [-wMax, wMax]
      %         u(2) \in [-vMax, vMax]
      %         d \in [-dMax, dMax]
      %
      % Inputs:
      %   x      - state: [xpos; ypos]
      %   thetaMin   - minimum angle
      %   thetaMax   - maximum angle
      %   v - speed 
      %   dMax   - disturbance bounds
      %
      % Output:
      %   obj       - a DubinsCar2D object
      
      if numel(x) ~= obj.nx
        error('Initial state does not have right dimension!');
      end
      
      if ~iscolumn(x)
        x = x';
      end
      
      if nargin < 2
        wRange = [-1 1];
      end
      
      if nargin < 3 
        vRange = [-5,5];
      end
      
      if nargin < 4
        dRange = {[0;0;0;0];[0;0;0;0]};
      end
      
      if nargin < 5
          L = 0.32;
      end
      
      if nargin < 6
        dims = 1:4;
      end
      
      if numel(wRange) <2
          wRange = [-wRange; wRange];
      end
      
      if numel(vRange) <2
          vRange = [-vRange; vRange];
      end
      
      if ~iscell(dRange)
          dRange = {-dRange,dRange};
      end
      
      % Basic vehicle properties
      obj.pdim = [find(dims == 1) find(dims == 2)]; % Position dimensions
      %obj.hdim = find(dims == 3);   % Heading dimensions
      obj.nx = length(dims);
      obj.nu = 2; % 2 control input (steering and velocity)
      obj.nd = 4; % [x_disturbance, y_disturbance, steering_disturbance, velocity_disturbance]
      
      obj.x = x;
      obj.xhist = obj.x;
      
      obj.wRange = wRange;
      obj.vRange = vRange;
      %obj.thetaMax = thetaMax;
      %obj.speed = speed;
      obj.dRange = dRange;
      obj.L = L;
      obj.t = 1; %0.1;
      obj.dt = 0.1;
      obj.dims = dims;
    end
    
  end % end methods
end % end classdef
