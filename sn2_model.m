function [mean,var] = sn2_model(z, x_p)
%SN2_MODEL Returns the mean and variance of the linear random
%variable sn2 sensor model
%   inputs: z - sensor value

a = 0.9894;
b = 0.0265;

% f1 = @(x) 1e-03*abs(0.9894*x + 0.0265);
f2= @(x) 1e-03*(0.4118*x + 0.0184);

mean = (z - b)/a;

if x_p < 0.3
    var=25;
else 
    var = 1/a^2*f2(x_p);
end


end

