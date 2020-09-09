% ENMT482 Assignment 1
clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");
test = readmatrix("test.csv");

[idx_1, t_1, x_1, u_1, ir1_1, ir2_1, ir3_1, ir4_1, sn1_1, sn2_1] = split_data(train1);
[idx_2, t_2, x_2, u_2, ir1_2, ir2_2, ir3_2, ir4_2, sn1_2, sn2_2] = split_data(train2);
[idx_t, t_t, x_t, u_t, ir1_t, ir2_t, ir3_t, ir4_t, sn1_t, sn2_t] = split_data(test);


% Which data set to use
dataSet = 1;

if (dataSet == 1)
    time = t_1;
    u = u_1;
    x = x_1;
    sn1 = sn1_1;
    sn2 = sn2_1;
elseif (dataSet == 2)
    time = t_2;
    u = u_2;
    x = x_2;
    sn1 = sn1_2;
    sn2 = sn2_2;
elseif (dataSet == 3)
    time = t_t;
    u = u_t;
    sn1 = sn1_t;
    sn2 = sn2_t;
end

%Initiial belief
x_posterior = 0;
p_posterior = 0.01;
n = length(time);       % Data set length

x_kal = zeros(n, 1);    % Predicted x values from kalman filter
k = zeros(length(time), 1);        % Kalman gain
x_kal(1) = x_posterior;
for i = 2:n
    dt = time(i) - time(i-1);
    
    % Predict - motion model
    [x_prior, var_m] = motion_model(x_posterior, u(i), dt);
    p_prior = p_posterior + var_m;
    
    % Sensor fusion
    num = 0;
    den = 0;
    for N = 1:2
        % Use sensor models to find x from sensor reading z
        if (N == 1)
            z = sn1(i);
            [x_sensor, var_s] = sn1_model(z);
        elseif (N == 2)
            z = sn2(i);
            [x_sensor, var_s] = sn2_model(z);
        end
        
        num = num + x_sensor/var_s;
        den = den + 1/var_s;
    end
    x_sensor = num/den;
    p = 1 / den;
    
    % Kalman gain
    k(i) = (1/p)/(1/p_prior + 1/p);
    
    % Bayes theorem
    x_posterior = k(i)*x_sensor + (1-k(i))*x_prior;
    p_posterior = 1/(1/p_prior + 1/p);

    x_kal(i) = x_posterior;
end

% Plot kalman prediction
figure(1)
hold on
scatter(time, x)
scatter(time, x_kal)
legend('Actual x', 'Kalman x')
xlabel('Time (s)')
ylabel('Distance x (m)')
hold off

% Plot kalman gain
figure(2)
plot(time, k);
title('Kalman Gain')