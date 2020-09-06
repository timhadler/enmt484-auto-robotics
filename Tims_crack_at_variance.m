% Trying to find variance from the given data

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

% Calibrartion data
time_c = cal(:, 2);
distance_c = cal(:, 3);
cVelocity_c = cal(:, 4);
ir1_c = cal(:, 5);
ir2_c = cal(:, 6);
ir3_c = cal(:, 7);
ir4_c = cal(:, 8);
sn1_c = cal(:, 9);
sn2_c = cal(:, 10);

% Calculate measured velocity
mVelocity_1 = zeros(length(time_1), 1);
mVelocity_2 = zeros(length(time_2), 1);

for i = 1:length(time_1)-1
    mVelocity_1(i) = (distance_1(i+1) - distance_1(i)) /(time_1(i+1)-time_1(i));
end

for i = 1:length(time_2)-1
    mVelocity_2(i) = (distance_2(i+1) - distance_2(i)) /(time_2(i+1)-time_2(i));
end

% Find a velocity model
% Fit both datasets to linear line
% Average the identified parameters
p_1 = polyfit(cVelocity_1, mVelocity_1, 1);
p_2 = polyfit(cVelocity_2, mVelocity_2, 1);
p = (p_1 + p_2) ./ 2;
velocityModel = @(u) p(1)*u + p(2);

% From velocity mdoel, find a motion model that gives distance, x
motionModel = @(u, x_p, dt) x_p + velocityModel(u)*dt;  %x_p = x(i-1)
save('motionModel', 'motionModel')

% Creat data arrays for the modeled velocity and modeled distance
modeledVelocity_1 = velocityModel(cVelocity_1);
modeledVelocity_2 = velocityModel(cVelocity_2);

modeledDistance_1 = zeros(length(time_1), 1);
modeledDistance_1(1) = distance_1(1);       % Inital x0
for i = 2:length(time_1)
    modeledDistance_1(i) = motionModel(cVelocity_1(i), modeledDistance_1(i-1), time_1(i)-time_1(i-1));
end

% Calculate variance over a window
mVar_1 = zeros(length(time_1), 1);
mVay_2 = zeros(length(time_1), 1);
win = 10;
for i = 1: length(time_1)
    if (i - win/2 < 1)
        lower_a = distance_1(1:i);
        lower_m = modeledDistance_1(1:i);
    else
        lower_a = distance_1(i-win/2:i);
        lower_m = modeledDistance_1(i-win/2:i);
    end
        
    if (i + win/2 > length(time_1))
        upper_a = distance_1(i+1:end);
        upper_m = modeledDistance_1(i+1:end);
    else
        upper_a = distance_1(i+1:i+win/2);
        upper_m = modeledDistance_1(i+1:i+win/2);
    end
       
    diff = [lower_a; upper_a] - [lower_m; upper_m];
    mVar_1(i) = mean(diff.^2);
end


% code to remove outliers
[sn1_c_rmOut] = filloutliers(sn1_c, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);
[sn2_c_rmOut, TF] = rmoutliers(sn2_c, 'movmean', 100, 'ThresholdFactor', 0.5);
[ir1_c_rmOut] = filloutliers(ir1_c, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);

% Model ir1 using only the data within the sensor range (0.15 - 1.5m)
distance_ir1 = distance_c(166:1373);
f = @(a, xdata) a(1)./(a(2)+a(3).*xdata.^(a(4)));
a0 = [1 1 1 1];
a = lsqcurvefit(f, a0, distance_ir1, ir1_c(166:1373));
%f_ir1_x = @(z) ((a(1) - a(2).*z)./(a(3).*z)).^(1/a(4));
f_ir1_x = @(z) ((a(1)./z-a(2))./a(3)).^(1/a(4));

% Create data array for the modeled x distance from ir1
% Currently removes outliers
ir1_x = zeros(length(time_c), 1);
for i = 1:length(time_c)
    x = f_ir1_x(ir1_c_rmOut(i));
    ir1_x(i) = x;
end
save('ir1_x model', 'ir1_x');

% Find variance fro the sesnors using window
% Prolly an easier way to do this
sVar_sn1 = zeros(length(time_c), 1);
sVar_sn2 = zeros(length(time_c), 1);
sVar_ir1 = zeros(length(time_c), 1);
win = 200;
for i = 1: length(time_c)
    if (i - win/2 < 1)
        lower_a_d = distance_c(1:i);
        lower_m_sn1 = sn1_c_rmOut(1:i);
        lower_m_ir1 = ir1_x(1:i);
    else
        lower_a_d = distance_c(i-win/2:i);
        lower_m_sn1 = sn1_c_rmOut(i-win/2:i);
        lower_m_ir1 = ir1_x(i-win/2:i);
    end
        
    if (i + win/2 > length(time_c))
        upper_a_d = distance_c(i+1:end);
        upper_m_sn1 = sn1_c_rmOut(i+1:end);
        upper_m_ir1 = ir1_x(i+1:end);
    else
        upper_a_d = distance_c(i+1:i+win/2);
        upper_m_sn1 = sn1_c_rmOut(i+1:i+win/2);
        upper_m_ir1 = ir1_x(i+1:i+win/2);
    end
       
    diff_sn1 = [lower_a_d; upper_a_d] - [lower_m_sn1; upper_m_sn1];
    diff_ir1 = [lower_a_d; upper_a_d] - [lower_m_ir1; upper_m_ir1];
    sVar_sn1(i) = mean(diff_sn1.^2);
    sVar_ir1(i) = mean(diff_ir1.^2);
%     sVar_sn1(i) = var([lower_m_sn1; upper_m_sn1]);
%     sVar_ir1(i) = var([lower_m_ir1; upper_m_ir1]);
end