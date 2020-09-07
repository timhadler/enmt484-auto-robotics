function [var] = find_variance(actual, model, win)
%find_variance, finds the variance between two datasets
%   Detailed explanation goes here

n = length(actual);
var = zeros(n, 1);

for i = 1:n
    if (i - win/2 < 1)
        lower_a = actual(1:i);
        lower_m = model(1:i);
    else
        lower_a = actual(i-win/2:i);
        lower_m = model(i-win/2:i);
    end
        
    if (i + win/2 > n)
        upper_a = actual(i+1:end);
        upper_m = model(i+1:end);
    else
        upper_a = actual(i+1:i+win/2);
        upper_m = model(i+1:i+win/2);
    end
       
    diff = [lower_a; upper_a] - [lower_m; upper_m];
    var(i) = mean(diff.^2);
end
end

