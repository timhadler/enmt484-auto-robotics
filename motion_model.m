function [mean,var] = motion_model(x_p, u, dt)
%MOTION_MODEL Returns the mean and variance of the linear random
%variable motion model
%   inputs: x_p - previous distance x
%           u - the commanded velocity
%           dt - difference between current and last time step


mean = x_p + (0.8435*u + -0.0029)*dt;
u = abs(u);
% if (u < 0.3)
%     var = 0.0076*u;
% else
%     var = 0.0134*u - 0.0011;
% end
var = (0.02418*u^2 + 9.1788e-05*u + 6.6596e-06);
end

