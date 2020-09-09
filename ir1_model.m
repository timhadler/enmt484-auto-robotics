function [mean,var] = ir1_model(z)
%SN1_MODEL Returns the mean and variance of the linear random
%variable sn1 sensor model
%   inputs: z - sensor value

% syms x

% f1 = @(x) a /(b + (c * (x^d)));

a = -20.3745;
b = 5.7630;
c = -53.1835;
d = 0.63;


mean = (((z - (a / (b + c * (x_prior ^ d)))) / - ((a * c * d * x_prior ^ (d - 1)) / (b + (c * (x_prior ^ d))))) + x_prior);
var = 0.1;

