function [mean,var] = ir1_model(z, x_prior)
%SN1_MODEL Returns the mean and variance of the linear random
%variable sn1 sensor model
%   inputs: z - sensor value

% syms x

% f1 = @(x) a /(b + (c * (x^d)));

a = 0.1686196; % -20.3745;
% b = 0; % 5.7630;
% c = 1; % -53.1835;
% d = 1;

f_ = a / x_prior;
f_dash = - a * (x_prior^-2);
mean = ((z - f_) / f_dash) + x_prior;
var = 0.001;