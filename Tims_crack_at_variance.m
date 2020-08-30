% Trying to find variance from the given data

% Motion model - just uses the commanded and measured
% velocity to calculate variance by finding the average of the squared
% difference

clc, clear, close all

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");
cal = readmatrix("calibration.csv");

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
var_1m = mean(dVelocity_1.^2);
var_2m = mean(dVelocity_2.^2);


% Sensor model
% split up the data into time, dist, commanded velocity etc. 
time_c = cal(:, 2);
distance_c = cal(:, 3);
cVelocity_c = cal(:, 4);
ir1_c = cal(:, 5);
ir2_c = cal(:, 6);
ir3_c = cal(:, 7);
ir4_c = cal(:, 8);
sn1_c = cal(:, 9);
sn2_c = cal(:, 10);


% Prolly need to remove outliers, not done here
% Need to use model for IR sensors to convert sensor output to meters
% Sonar sensors output is in meters so dont have to convert output
var_sn1 = mean((distance_c - sn1_c).^2);
var_sn2 = mean((distance_c - sn2_c).^2);