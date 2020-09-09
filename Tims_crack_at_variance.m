% Selectively ignore outliers
for i=1:length(t_c)
    if sn1_c(i) > 6
        sn1_c(i) = nan;
    end

    if (sn1_c(i) < 0.3777 && x_c(i) > 2)
        sn1_c(i) = nan;
    end
    
    if (sn2_c(i) > 3.5)
        sn2_c(i) = nan;
    end
end


nan = prod(isfinite(sn1_c), 2);
%sn1_c = filloutliers(sn1_c, 'next', 'movmean', 20, 'ThresholdFactor', 3);
%sn2_c = filloutliers(sn2_c, 'next', 'movmean', 25, 'ThresholdFactor', 0.5);

% figure(2)
% scatter(x_c, sn1_c)

% Fit linear curves to sonar sensors
p = polyfit(x_c(nan==1), sn1_c(nan==1), 1);
sn1_z = @(x) p(1)*x+p(2);
sn1_x = @(z) (z-p(2))/p(1);

nan = prod(isfinite(sn2_c), 2);
p = polyfit(x_c(nan==1), sn2_c(nan==1), 1);
sn2_z = @(x) p(1)*x+p(2);
sn2_x = @(z) (z-p(2))/p(1);

window = 10;
var_sn1 = find_variance(sn1_c, sn1_z(x_c), window);
var_sn2 = find_variance(sn2_c, sn2_z(x_c), window);
% var_sn1 = find_variance(x_c, sn1_x(x_c), window);
% var_sn2 = find_variance(x_c, sn2_x(x_c), window);


p1 = polyfit(x_c(1:1800), var_sn1(1:1800), 1);
nan =prod(isfinite(var_sn1(1800:end)), 2);
x = x_c(1800:end);
v=var_sn1(1800:end);
p2 = polyfit(x(nan==1), v(nan==1), 1);

p1_f = @(x) p1(1)*x+p1(2);
p2_f = @(x) p2(1)*x+p2(2);
p3_f = @(x) p3(1)*x+p3(2);

plot(x_c, var_sn1)


nan =prod(isfinite(var_sn2(1:317)), 2);
x = x_c(1:317);
v=var_sn1(1:317);
p1 = polyfit(x(nan==1), v(nan==1), 1);
p2 = polyfit(x_c(317:2910), var_sn2(317:2910), 1);
p3 = polyfit(x_c(2910:end), var_sn2(2910:end), 1);

p1_f = @(x) p1(1)*x+p1(2);
p2_f = @(x) p2(1)*x+p2(2);

mean_m = zeros(length(t_c), 1);
var_m = zeros(length(t_c), 1);
for i=1:length(t_c)
    [mean_m(i),var_m(i)] = sn2_model(sn2_c(i));
end