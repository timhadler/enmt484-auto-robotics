function [mean,var] = sn1_model(z, x_p)
%SN1_MODEL Returns the mean and variance of the linear random
%variable sn1 sensor model
%   inputs: z - sensor value



a = 0.999;
b = -0.0216;

f1 = @(x) abs(0.0658*x - 0.0330);
f2= @(x) abs(6.5920*x - 14.3937);


mean = (z - b)/a;

if x_p < 2.1315
    var = 1/a^2*f1(x_p);
else
    var = 1/a^2*f2(x_p);
end


end