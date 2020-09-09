function [mean,var] = sn1_model(z)
%SN1_MODEL Returns the mean and variance of the linear random
%variable sn1 sensor model
%   inputs: z - sensor value

syms x

f1 = @(x) abs(0.0338*x - 0.0112);
f2= @(x) abs(0.4314*x - 0.7462);

mean = (z - 0.0484)/0.8890;

if mean < 2
    var = f1(mean);
else
    var = f2(mean);
end

end