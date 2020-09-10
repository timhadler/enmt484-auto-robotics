% find_variance, finds the variance between two datasets
% related in a non-linear way
% Detailed explanation goes here

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
isOut_ir1 = zeros(length(t_c), 1);
isOut_ir2 = zeros(length(t_c), 1);
for i=1:length(t_c)
    if ir1_c(i) > 6
        isOut_ir1(i) = 1;
    end

    if (ir1_c(i) < 0.3777 && x_c(i) > 2)
        isOut_ir1(i) = 1;
    end
    
    if (sn2_c(i) > 3.5)
        isOut_ir2(i) = 1;
    end
end

window = 10;

% Function for possie from sensor
ir1_x = @(z) 0.1686196/z;

% var_ir2 = find_variance(sn1_c, sn1_z(x_c), window);
var_ir1 = find_variance(x_c, ir1_x(ir1_c), window);

% Plot fitted sensor models
figure(7)
hold on
scatter(x_c, ir1_c)
plot(x_c, ir1_x(ir1_c))
title('Fitted sn1')
hold off
