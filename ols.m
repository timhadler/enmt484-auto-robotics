%Joseph Green 05/2020

clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");
cal = readmatrix("calibration.csv");

% Split data, time t, true distance x, commanded velocity u
% sensor data- 4 infrared sensors, 2 sonar sensors
% [idx_1, t_1, x_1, u_1, ir1_1, ir2_1, ir3_1, ir4_1, sn1_1, sn2_1] = split_data(train1);
% [idx_2, t_2, x_2, u_2, ir1_2, ir2_2, ir3_2, ir4_2, sn1_2, sn2_2] = split_data(train2);
% [idx_c, t_c, x_c, u_c, ir1_c, ir2_c, ir3_c, ir4_c, sn1_c, sn2_c] = split_data(cal);

load('variances')

x = x_c;
y = var_sn1;

i = 5;
j = 1;

% Read in data
% code here

n = length(x);
while (i < (n - 4))
    x_b = x(i);
    A_one = [ones(length(x(1:i)),1), x(1:i)];
    theta_one = ((A_one'*A_one)^-1)*A_one'*y(1:i);
    A_two = [ones(length(x(i:end)),1), x(i:end)];
    theta_two = ((A_two'*A_two)^-1)*A_two'*y(i:end);
    y_i = y((i):end);
    x_last = x(i-1) < x(i);
    x_next = x(i) < x(i+1);
    if (((x_last) & (x_next)) & (theta_one(2) ~= theta_two(2)))
        R(j) = ((y(1:i)' - theta_one'*A_one')*(y(1:i) - A_one*theta_one));
        R(j) = R(j) + ((y_i' - theta_two'*A_two')*(y_i - A_two*theta_two));
        if (i == 1542)    %  After we have found the index via R == min(R)
                        %  and index_array(25)
            theta = [theta_one; theta_two] %Thta gives results
        end
        index_array(j) = i;
        j = j+1;
    else
    end
    i = i + 1;
end

% After index array is found via index_array(find(R == min(R))
% put index for i above inside loop to find [theta_one; theta_two]
% This is the OLS gradient/intercept

