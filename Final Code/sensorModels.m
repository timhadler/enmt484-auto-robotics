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

% Selectively ignore outliers for fitting models
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
p = p + [0.11 -0.07];
sn1_z = @(x) p(1)*x+p(2);
sn1_x = @(z) (z-p(2))/p(1);
["sn1(x) model parameters:" p]

p = polyfit(x_c(~isOut_sn2), sn2_c(~isOut_sn2), 1);
sn2_z = @(x) p(1)*x+p(2);
sn2_x = @(z) (z-p(2))/p(1);
["sn2(x) model parameters:" p]


window = 10;
var_sn1 = find_variance(x_c, sn1_x(sn1_c), window);
var_sn2 = find_variance(x_c, sn2_x(sn2_c), window);

% Find variance models
p1= polyfit(x_c(1:2000), var_sn1(1:2000), 1);
p2 = polyfit(x_c(2000:end), var_sn1(2000:end), 1);
p2 = p2 + [2 -4];
varModel1_sn1 = @(x)p1(1)*x+p1(2);
varModel2_sn1 = @(x)p2(1)*x+p2(2);

p = polyfit(x_c(275:end), var_sn2(275:end), 1)
varModel_sn2 = @(x) p(1)*x + p(2);



% Ir sensors
f = @(a, xdata) a(1)./(a(2) + xdata) +a(3)*xdata + a(4);
p = lsqcurvefit(f, [1 1 1 1], x_c, ir3_c);
%ir3_x = @(z) p(3)*x.^2 + (p(2) + p(4) - z)*x + p(1) + p(2)*p(4);

var_ir3 = find_variance(ir3_c, f(p,x_c), 10);



%Plotting

% Plot fitted sensor models
figure(7)
hold on
scatter(x_c, sn1_c)
plot(x_c, sn1_z(x_c))
%title('Fitted sn1')
legend('Data', 'Model')
xlabel('Distance (m)')
ylabel('Sensor output (m)')
hold off

figure(8)
hold on
scatter(x_c, sn2_c)
plot(x_c, sn2_z(x_c))
%title('Fitted sn2')
legend('Data', 'Model')
ylabel('Sensor output (m)')
xlabel('Distance (m)')
hold off

figure(9)
hold on
scatter(x_c, ir3_c)
plot(x_c, f(p, x_c))
legend('Data', 'Model')
xlabel('Distance (m)')
ylabel('Sensor output (v)')
hold off

% Plot variance
figure(10)
hold on
scatter(x_c, var_sn1)
plot(x_c(1:2000), varModel1_sn1(x_c(1:2000)))
plot(x_c(2000:end), varModel2_sn1(x_c(2000:end)))
%title('sn1Variance')
legend('Measured', 'Modeled', 'Modeled')
xlabel('Distance (m)')
ylabel('Variance')
hold off

figure(11)
hold on
scatter(x_c, var_sn2)
plot(x_c(275:end), varModel_sn2(x_c(275:end)))
legend('Measured', 'Modeled')
xlabel('Distance (x)')
ylabel('Variance')
%title('sn2 variance')

figure(12)
scatter(x_c, var_ir3)
%title('ir3 variance')
ylabel('Variance')
xlabel('Distance (m)')
