function [idx, t, x, u, ir1, ir2, ir3, ir4, sn1, sn2] = split_data(data)
%SPLIT_DATA splits data file for ENMT482 Assignment 1
%   Returns index, time, range, commanded velocity, 
%       data for the three infra-red sensors, and two sonar sensors

% split up the data into time, dist, commanded velocity etc. 
idx = data(:, 1);
t = data(:, 2);
x = data(:, 3);
u = data(:, 4);
ir1 = data(:, 5);
ir2 = data(:, 6);
ir3 = data(:, 7);
ir4 = data(:, 8);
sn1 = data(:, 9);
sn2 = data(:, 10);
end

