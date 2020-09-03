%Joseph Green 05/2020
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
        index_array(j) = i;
        j = j+1;
    else
        
    end
    i = i + 1;
end