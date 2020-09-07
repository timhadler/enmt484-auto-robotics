% ENMT482 Assignment 1
clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");
cal = readmatrix("calibration.csv");
test = readmatrix("test.csv");

[idx_1, t_1, x_1, u_1, ir1_1, ir2_1, ir3_1, ir4_1, sn1_1, sn2_1] = split_data(train1);
[idx_2, t_2, x_2, u_2, ir1_2, ir2_2, ir3_2, ir4_2, sn1_2, sn2_2] = split_data(train2);
[idx_c, t_c, x_c, u_c, ir1_c, ir2_c, ir3_c, ir4_c, sn1_c, sn2_c] = split_data(cal);

%sn1 = filloutliers(sn1, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);
%sn2 = filloutliers(sn2, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);

% Motion model
% Calculate measured velocity
mVel_1 = zeros(length(t_1), 1);
mVel_2 = zeros(length(t_2), 1);

for i = 1:length(t_1)-1
    mVel_1(i) = (x_1(i+1) - x_1(i)) /(t_1(i+1)-t_1(i));
end

for i = 1:length(t_2)-1
    mVel_2(i) = (x_2(i+1) - x_2(i)) /(t_2(i+1)-t_2(i));
end

% Find a velocity model
% Fit both datasets to linear line
% Average the identified parameters
p_1 = polyfit(u_1, mVel_1, 1);
p_2 = polyfit(u_2, mVel_2, 1);
p = (p_1 + p_2) ./ 2;
velocityModel = @(u) p(1)*u + p(2);

% Find motion model variance
window = 10;    % Looked at modeled var against measured var to find good window
var_m1 = find_variance(u_1, velocityModel(u_1), window);
var_m2 = find_variance(u_2, velocityModel(u_2), window);

% figure(1)
% hold on
% plot(t_1, u_1)
% plot(t_1, velocityModel(u_1))
% hold off
% 
% figure(2)
% plot(t_1, var_m1)
% 
% figure(3)
% hold on
% plot(t_2, u_2)
% plot(t_2, velocityModel(u_2))
% hold off
% 
% figure(4)
% plot(t_2, var_m2)

% figure(5)
% scatter(u_1, var_m1)

p_1 = polyfit(u_1, var_m1, 2);
p_2 = polyfit(u_2, var_m2, 2);
p = (p_1 + p_2) / 2;
varModel_1 = @(u) p_1(1)*u.^2 + p_1(2)*u + p_1(3);
varModel_2 = @(u) p_2(1)*u.^2 + p_2(2)*u + p_2(3);
varModel = @(u) p(1)*u.^2 + p(2)*u + p(3);
% figure(5)
% hold on
% plot(t_1, varModel(u_1))
% plot(t_1, var_m1)
% legend('modeled', 'measured')
% hold off
% figure(6)
% hold on
% plot(t_2, varModel(u_2))
% plot(t_2, var_m2)
% legend('modeled', 'measured')
% hold off

% Put this in function script
motionModel = @(x_prev, u, dt) x_prev + u*dt + varModel(u);
function [mean, var] = motionModel_f(x_prev, u, dt)
mean = x_prev + u*dt;
var = varModel(u);
end

[mean_m, var_m] = motionModel(x_1(25), u_1(25), (t_1(25)-t_1(24)));

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