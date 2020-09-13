function [var] = find_variance(actual, model, win)
%find_variance, finds the variance between two datasets




diff = actual - model;
var = movmean(diff.^2, win);

end

