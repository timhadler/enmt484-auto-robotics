function [mean,var] = ir3_model(z, x_p)
%IR3_MODEL Returns the mean and variance of the none linear random
%variable sn1 sensor model, applies 1st order Taylor-Series apprximation
%   inputs: z - sensor value


k1 = 0.2965;
k2 = -0.0017;
k3 = 0.1796;
k4 = -0.0072;

% Functions for the sensor model z, and derivative zd
z_f = @(x) k1/(k2 + x) + k3*x + k4;
zd_f = @(x) -k1/(k2+x)^2 + k3;

mean = (z - z_f(x_p))/zd_f(x_p);

if (x_p < 0.15 || x_p > 1.6)
    var = 0.02;
else
    var = 0.01;
end
