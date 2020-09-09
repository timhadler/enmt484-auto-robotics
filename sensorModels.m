% Sensor models
clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");
cal = readmatrix("calibration.csv");

% Split data, time t, true distance x, commanded velocity u
% sensor data- 4 infrared sensors, 2 sonar sensors
[idx_1, t_1, x_1, u_1, ir1_1, ir2_1, ir3_1, ir4_1, sn1_1, sn2_1] = split_data(train1);
[idx_2, t_2, x_2, u_2, ir1_2, ir2_2, ir3_2, ir4_2, sn1_2, sn2_2] = split_data(train2);
[idx_c, t_c, x_c, u_c, ir1_c, ir2_c, ir3_c, ir4_c, sn1_c, sn2_c] = split_data(cal);

% Selectively ignore outliers
isOut_sn1 = zeros(length(t_c), 1);
isOut_sn2 = zeros(length(t_c), 1);
for i=1:length(t_c)
    if sn1_c(i) > 6
        isOut_sn1(i) = 1;
    end

    if (sn1_c(i) < 0.3777 && x_c(i) > 2)
        isOut_sn1(i) = 1;
    end
    
    if (sn2_c(i) > 3.5)
        isOut_sn2(i) = 1;
    end
end

% Fit linear curves to sonar sensors, ignore outliers
p = polyfit(x_c(~isOut_sn1), sn1_c(~isOut_sn1), 1);
sn1_z = @(x) p(1)*x+p(2);
sn1_x = @(z) (z-p(2))/p(1);
["sn1(x) model parameters:" p]

p = polyfit(x_c(~isOut_sn2), sn2_c(~isOut_sn2), 1);
sn2_z = @(x) p(1)*x+p(2);
sn2_x = @(z) (z-p(2))/p(1);
["sn2(x) model parameters:" p]


% Ir sensors
syms x
a0 = [2, 1, 1, 0.5];
%f = @(a, xdata) a(1)./(a(2) + a(3)*xdata.^(a(4)));
f = @(a, xdata) a(1)./(a(2) + a(3)*xdata.^(a(4)));
p = lsqcurvefit(f, [1 1 1 1], x_c(1:1000), ir3_c(1:1000));




window = 10;
% var_sn1 = find_variance(sn1_c, sn1_z(x_c), window);
% var_sn2 = find_variance(sn2_c, sn2_z(x_c), window);
var_sn1 = find_variance(x_c, sn1_x(x_c), window);
var_sn2 = find_variance(x_c, sn2_x(x_c), window);

% Find variance models
% p = polyfit(x_c, var_sn1, 1);
% varModel_sn1 = @(x) p(1)*x + p(2);
p= polyfit(x_c, var_sn1, 2);
varModel_sn1 = @(x)p(1)*x.^2+p(2)*x+p(3);
["sn1 variance parameters:" p]

% p = polyfit(x_c, var_sn2, 1);
% varModel_sn2 = @(x) p(1)*x + p(2);
p= polyfit(x_c, var_sn2, 2);
varModel_sn2 = @(x)p(1)*x.^2+p(2)*x+p(3);
["sn2 variance parameters:" p]

%Plotting
%plot sensor data from the three datsets to determine outliers
% scatter(x_c, sn1_c)
% title('sn1 cal')
% figure(2)
% plot(x_1, sn1_1)
% plot(x_1, sn1_1)
% title('sn1 train1')
% figure(3)
% figure(2)
% scatter(x_1, sn1_1)
% figure(3)
% title('sn1 train2')
% scatter(x_2, sn1_2)
% title('sn1 train2')
% figure(2)
% title('sn1 train1')
% figure(4)
% scatter(x_c, sn2_c)
% title('sn2 cal')
% figure(5)
% scatter(x_1, sn2_1)
% title('sn2 train1')
% figure(6)
% scatter(x_2, sn2_2)
% title('sn1 train2')

% Plot fitted sensor models
figure(7)
hold on
scatter(x_c, sn1_c)
plot(x_c, sn1_z(x_c))
title('Fitted sn1')
hold off

figure(8)
hold on
scatter(x_c, sn2_c)
plot(x_c, sn2_z(x_c))
title('Fitted sn2')
hold off

% Plot variance
figure(9)
hold on
scatter(x_c, var_sn1)
plot(x_c, varModel_sn1(x_c))
title('sn1Variance')
legend('measured', 'modeled')
hold off

figure(10)
hold on
scatter(x_c, var_sn2)
plot(x_c, varModel_sn2(x_c))
title('sn2 variance')
