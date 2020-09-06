clc, clear, close all;

data = readmatrix("training2.csv");
load('motionModel.mat');

% split up the data into time, dist, commanded velocity etc. 
time = data(:, 2);
distance_x = data(:, 3);
cVel = data(:, 4);
ir1 = data(:, 5);
ir2 = data(:, 6);
ir3 = data(:, 7);
ir4 = data(:, 8);
sn1 = data(:, 9);
sn2 = data(:, 10);

%sn1 = filloutliers(sn1, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);
%sn2 = filloutliers(sn2, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);

% Sensor models
%sn1_model z = 0.9183x + 0.0446;
sn1_x = @(zi) (zi - 0.03)/0.9183;
sn1_var = 0.8851;

%sn2_model z = 1.007x - 0.0141
sn2_x = @(zi) (zi - 0.02)/1.007;
sn2_var = 1.1002;

% Motion model - Xn = Xn-1 + udt + W
motion_var = 0.0018;

% Parameters for kalman filter function
kalman_data = [time cVel];
motion = motionModel;
initial_belief = [distance_x(1) 0.1];
% Defines the sensors to be used in the filter, make sure the order 
% is the same in each list
sensor_data = [sn1];
sensors = {sn1_x};
sensor_var = [sn1_var];

predicted_x = kalman_filter(kalman_data, sensor_data, sensors, sensor_var, motion, motion_var, initial_belief);

% Plot results
figure(1)
hold on
scatter(time, distance_x)
scatter(time, predicted_x)
legend('Actual x', 'Predicted x')
xlabel('Time (s)')
ylabel('Distance x (m)')
hold off