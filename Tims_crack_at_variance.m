% Trying to find variance from the given data
%
% Motion model - just uses the commanded and measured
% velocity to calculate variance by finding the average of the squared
% difference

clc, clear, close all

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");

% split up the data into time, dist, commanded velocity etc. 
time_1 = train1(:, 2);
distance_1 = train1(:, 3);
cVelocity_1 = train1(:, 4);
ir1_1 = train1(:, 5);
ir2_1 = train1(:, 6);
ir3_1 = train1(:, 7);
ir4_1 = train1(:, 8);
sn1_1 = train1(:, 9);
sn2_1 = train1(:, 10);

time_2 = train2(:, 2);
distance_2 = train2(:, 3);
cVelocity_2 = train2(:, 4);
ir1_2 = train2(:, 5);
ir2_2 = train2(:, 6);
ir3_2 = train2(:, 7);
ir4_2 = train2(:, 8);
sn1_2 = train2(:, 9);
sn2_2 = train2(:, 10);

% Calculate measured velocity
mVelocity_1 = zeros(length(time_1), 1);
mVelocity_2 = zeros(length(time_2), 1);

for i = 1:length(time_1)-1
    mVelocity_1(i) = (distance_1(i+1) - distance_1(i)) /(time_1(i+1)-time_1(i));
end

for i = 1:length(time_2)-1
    mVelocity_2(i) = (distance_2(i+1) - distance_2(i)) /(time_2(i+1)-time_2(i));
end

% Calculate commanded and measured velocity difference
dVelocity_1 = mVelocity_1 - cVelocity_1;
dVelocity_2 = mVelocity_2 - cVelocity_2;

% Calculate variance by squaring the differnece and finding the average
var_1 = mean(dVelocity_1.^2)
var_2 = mean(dVelocity_2.^2)
