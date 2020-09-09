function [mean,var] = sn2_model(z)
%SN2_MODEL Returns the mean and variance of the linear random
%variable sn2 sensor model
%   inputs: z - sensor value

syms x

f1 = @(x) 1e-03*abs(0.9894*x + 0.0265);
f2= @(x) abs(-0.0012*x + 0.0028);

mean = (z - 0.0265)/0.9894;

% if mean < 0.3
%     var=0.15;%var = f1(mean);
% elseif (mean < 3.2705)
%     var = f2(mean);
% else 
%     var = 0.1;
% end

var = 0.00011523*mean^2 - 0.00057555*mean + 0.00071867;
end

