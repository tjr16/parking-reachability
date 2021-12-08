function uOpt = optCtrl(obj, ~, ~, deriv, uMode)
% uOpt = optCtrl(obj, t, y, deriv, uMode)

%% Input processing
if nargin < 5
  uMode = 'min';
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

%% Optimal control
% if strcmp(uMode, 'max')
%   uOpt = (deriv{obj.dims==3}>=0)*obj.wRange(2) + (deriv{obj.dims==3}<0)*(obj.wRange(1));
% elseif strcmp(uMode, 'min')
%   uOpt = (deriv{obj.dims==3}>=0)*(obj.wRange(1)) + (deriv{obj.dims==3}<0)*obj.wRange(2);
if strcmp(uMode, 'max')

  if any(obj.dims == 3) % heading
    uOpt{1} = (deriv{obj.dims==3}>=0)*obj.wRange(2) + ...
      (deriv{obj.dims==3}<0)*obj.wRange(1);
  end

  if any(obj.dims == 4) % velocity
    uOpt{2} = (deriv{obj.dims==4}>=0)*obj.vRange(2) + ...
      (deriv{obj.dims==4}<0)*(obj.vRange(1));
  end

elseif strcmp(uMode, 'min')

  if any(obj.dims == 3) % heading
    uOpt{1} = (deriv{obj.dims==3}>=0)*obj.wRange(1) + ...
      (deriv{obj.dims==3}<0)*obj.wRange(2);
  end

  if any(obj.dims == 4) % velocity
    uOpt{2} = (deriv{obj.dims==4}>=0)*obj.vRange(1) + ...
      (deriv{obj.dims==4}<0)*obj.vRange(2);
  end
else
  error('Unknown uMode!')
end

end