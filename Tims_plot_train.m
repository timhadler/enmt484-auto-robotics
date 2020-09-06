clc, clear, close all;

train1 = readmatrix("training1.csv");
train2 = readmatrix("training2.csv");

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

% Remove outliers
sn1_1_rmOute = filloutliers(sn1_1, 'nearest', 'movmean', 30, 'ThresholdFactor', 0.5);
sn2_1_rmOut = filloutliers(sn2_1, 'nearest', 'movmean', 25, 'ThresholdFactor', 0.5);

[sn1_1_rmOut, TF] = rmoutliers(sn1_1, 'movmean', 20, 'ThresholdFactor', 0.4);

figure(4)
scatter(distance_1, sn1_1_rmOute);
figure(6)
scatter(distance_1(~TF), sn1_1_rmOut)

figure(5)
scatter(distance_1, sn1_1);

sn1_2_rmOut = polyval(polyfit(distance_2, sn1_2, 1), distance_2);
sn2_2_rmOut = polyval(polyfit(distance_2, sn2_2, 1), distance_2);


ir1_1_movAvg = movmean(ir1_1, 20);
ir3_1_movAvg = movmean(ir3_1, 20);


% Plot config 1
figure(1)
subplot(2, 3, 1)
plot(distance_1, ir1_1_movAvg)
title("IR 1 avg")
xlabel("x")
ylabel("z")

subplot(2, 3, 2)
plot(distance_1, ir2_1)
title("IR 2")
xlabel("x")
ylabel("z")

subplot(2, 3, 4)
plot(distance_1, ir3_1_movAvg)
title("IR 3 avg")
xlabel("x")
ylabel("z")

subplot(2, 3, 5)
plot(distance_1, ir4_1)
title("IR 4")
xlabel("x")
ylabel("z")

subplot(2, 3, 3)
%plot(distance_1, sn1_1_rmOut)
title("Sonar 1")
xlabel("x")
ylabel("z")

subplot(2, 3, 6)
plot(distance_1, sn2_1_rmOut)
title("Sonar 2")
xlabel("x")
ylabel("z")


% Plot config 2
figure(2)
subplot(2, 3, 1)
plot(distance_2, ir1_2)
title("IR 1")
xlabel("x")
ylabel("z")

subplot(2, 3, 2)
plot(distance_2, ir2_2)
title("IR 2")
xlabel("x")
ylabel("z")

subplot(2, 3, 4)
plot(distance_2, ir3_2)
title("IR 3")
xlabel("x")
ylabel("z")

subplot(2, 3, 5)
plot(distance_2, ir4_2)
title("IR 4")
xlabel("x")
ylabel("z")

subplot(2, 3, 3)
plot(distance_2, sn1_2_rmOut)
title("Sonar 1")
xlabel("x")
ylabel("z")

subplot(2, 3, 6)
plot(distance_2, sn2_2_rmOut)
title("Sonar 2")
xlabel("x")
ylabel("z")


figure(3)
subplot(2, 2, 3)
hold on
%scatter(distance_1, sn1_1_rmOut)
scatter(distance_1, distance_1)
hold off
title('Sonar 1 minus outliers')

subplot(2, 2, 1)
scatter(distance_1, sn1_1)
title("Sonar 1")

subplot(2, 2, 4)
hold on
scatter(distance_1, sn2_1_rmOut)
scatter(distance_1, distance_1);
hold off
title("Sonar 2 minus outliers")

subplot(2, 2, 2)
scatter(distance_1, sn2_1)
title("Sonar 2")