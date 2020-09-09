% Motion model
clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");

% Split data, time t, true distance x, commanded velocity u
% sensor data- 4 infrared sensors, 2 sonar sensors
[idx_1, t_1, x_1, u_1, ir1_1, ir2_1, ir3_1, ir4_1, sn1_1, sn2_1] = split_data(train1);
[idx_2, t_2, x_2, u_2, ir1_2, ir2_2, ir3_2, ir4_2, sn1_2, sn2_2] = split_data(train2);

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
% Fit both measured velocities to commanded velocity with a linear model
% Average the identified parameters for final velocity model
pm_1 = polyfit(u_1, mVel_1, 1);
pm_2 = polyfit(u_2, mVel_2, 1);
pm = (pm_1 + pm_2) ./ 2;
% velocityModel_1 = @(u) p_1(1)*u + p_1(2);
% velocityModel_2 = @(u) p_2(1)*u + p_2(2);
velocityModel = @(u) pm(1)*u + pm(2);
mModel = @(x_p, u, dt) x_p + (pm(1)*u + pm(2))*dt; 


% Find motion model variance
window = 10;    % Looked at modeled var against measured var to find good window
var_1 = find_variance(u_1, velocityModel(u_1), window);
var_2 = find_variance(u_2, velocityModel(u_2), window);

% Fit single linear line to variance
pv = polyfit(abs(u_1), var_1, 1);
pv = polyfit(abs(u_1), var_1, 2);
varModel = @(u) pv(1)*u.^2 + pv(2)*u + pv(3);

% % 2 linear curves to fit variance
% p1 = polyfit(abs(u_1(3894:4055)), var_1(3894:4055), 1);
% p2 = polyfit(abs(u_1(4513:4574)), var_1(4513:4574), 1);
% 
%  
% p_1 = polyfit(abs(u_1), var_1, 1);
% p_2 = polyfit(abs(u_2), var_2, 1);
% p = (p_1 + p_2) / 2;
% varModel_1 = @(u) p_1(1)*u + p_1(2);
% varModel_2 = @(u) p_2(1)*u + p_2(2);
% varModel_m = @(u) (p(1)*u + p(2));


["Motion model mean parameters:" pm]
["Motion model variance parameters:" pv]



% Plotting

% Plot distance and velocity for train1 data
% figure(1)
% plot(t_1, x_1)
% title('Distance train1')

% figure(2)
% hold on
% plot(t_1, u_1)
% plot(t_1, mVel_1)
% title('Velocity train1')
% legend('Commanded', 'Measured')
% hold off


% % Plot velocity model error
% figure(2)
% hold on
% plot(t_1, mVel_1 - velocityModel_1(u_1))
% plot(t_1, mVel_1 - velocityModel_2(u_1))
% plot(t_1, mVel_1 - velocityModel(u_1))
% title('Velocity model error')
% legend('train1', 'train2', 'avg')
% hold off

% Plot commanded and modeled velocity
figure(3)
hold on
plot(t_1, u_1)
plot(t_1, velocityModel(u_1))
title('Velocity train1')
legend('Commanded', 'Modeled')
hold off


% Plot velocity model variance (train1)
figure(5)
hold on
scatter(abs(u_1), var_1)
plot(abs(u_1), varModel(abs(u_1)))
title('Variance against commanded vel train1')
legend('measured', 'modeled')
hold off

figure(6)
hold on
scatter(t_1, var_1)
plot(t_1, varModel(abs(u_1)))
title('Variance against time trani1')
legend('measured', 'modeled')
hold off


