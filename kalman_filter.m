function [x_pred] = kalman_filter(data, sensor_data, sensors, sensor_var, motion, motion_var, initial_belief)
%kalman_filter, uses kalman filtering, sensor fusion and bayes theorem
%to predict posiiton x for Robotics Assignment 1 Part A
%
%   Data - an nx2 matrix [time, commanded velocity], n = number of samples
%   Sensor_data - an nxN matrix of sensor data, N - number of sensors
%   Sensors - a 1xN vector of sensor model functions, 
%                   order must be the same as in senor_data
%   sensor_var - a 1xN vector of sensor model variances
%   motion_var - variance, Var[W], for the motion model, X = X_prior + udt + W
%   x_pred - an nx1 vector of the predicted x for each step
%   inital_belief, the initial belief in the form: [E[X0], Var[X0]]

syms x;

time = data(:, 1);
u = data(:, 2);
n = length(time);

%Initiial belief
x_posterior = initial_belief(1);
p_posterior = initial_belief(2);

x_pred = zeros(n, 1);
x_pred(1) = x_posterior;
for i = 2:n
    dt = time(i) - time(i-1);
    
    % Predict - motion model
    x_prior = motion(u(i), x_posterior, dt);
    %x_prior = x_posterior + u(i) * dt;
    p_prior = p_posterior + motion_var;
    
    % Sensor fusion
    num = 0;
    den = 0;
    for N = 1:length(sensor_var)
        % Sensor reading, converted to distance x
        sensor = sensors{N};
        z = sensor_data(i, N);
        x_sensor = sensor(z);
        
        num = num + x_sensor/sensor_var(N);
        den = den + 1/sensor_var(N);
    end
    x_sensor = num/den;
    p = 1 / den;
    
    % Kalman gain
    k = (1/p)/(1/p_prior + 1/p);
    
    % Bayes theorem
    x_posterior = k*x_sensor + (1-k)*x_prior;
    p_posterior = 1/(1/p_prior + 1/p);

    x_pred(i) = x_posterior;
end
end

