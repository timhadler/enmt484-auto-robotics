# ENMT482 Assignment One -- Sensor Fusion (first part)
# Tim Hadler and Joseph Green
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

# Load data from calibration.csv file
filename = 'calibration.csv' # Filename
data = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data

# Split into columns
index, time, range_1, velocity_command, raw_ir1, raw_ir2, raw_ir3, raw_ir4, sonar1, sonar2 = data.T #Data now segmented

#Plot raw data
plt.figure(figsize=(8, 7))

# Reject outliers in raw_ir1, raw_ir2, and raw_ir3 data
# time or range???
boolArr1 = abs(raw_ir1 - np.mean(raw_ir1)) < 2 * np.std(raw_ir1)
raw_ir1_without = raw_ir1[boolArr1]
time_1 = time[boolArr1]

boolArr2 = abs(raw_ir2 - np.mean(raw_ir2)) < 2 * np.std(raw_ir2)
raw_ir2_without = raw_ir2[boolArr2]
time_2 = time[boolArr2]

boolArr3 = abs(raw_ir3 - np.mean(raw_ir3)) < 2 * np.std(raw_ir3)
raw_ir3_without = raw_ir3[boolArr3]
time_3 = time[boolArr3]

#Plot data without outiers on same graph
plt.subplot(221)
plt.plot(time, velocity_command, '.', alpha=0.5)
plt.title('Velocity command')
plt.ylabel('Measurement (V)')

plt.subplot(222)
plt.plot(time, raw_ir1, '.', alpha=0.5) #raw_ir1_without,time_1
plt.title('IR1 with outliers')
plt.ylabel('Measurement (V)')

plt.subplot(223)
plt.plot(time, raw_ir2, '.', alpha=0.5) #raw_ir2_without,time_2
plt.title('IR2 with outliers')
plt.ylabel('Measurement (V)')

plt.subplot(224)
plt.plot(time, raw_ir3, '.', alpha=0.5) #raw_ir3_without,time_3
plt.title('IR3 with outliers')
plt.ylabel('Measurement (V)')
plt.show()

## Find elastic region for IR1
#i = 4
#n = len(raw_ir1)
#while (i < (n - 4)):
    #x_b = raw_ir1[i];
    #A_one = np.array([ones(length(x(1:i)),1), x(1:i)])
    #theta_one = ((A_one'*A_one)^-1)*A_one'*y(1:i)
    #A_two = [ones(length(x(i:end)),1), x(i:end)]
    #theta_two = ((A_two'*A_two)^-1)*A_two'*y(i:end)
    #y_i = y((i):end)
    #x_last = x(i-1) < x(i)
    #x_next = x(i) < x(i+1)
    ##if (((x_last) & (x_next)) & (theta_one(2) ~= theta_two(2))):
        ##R(j) = ((y(1:i)' - theta_one'*A_one')*(y(1:i) - A_one*theta_one))
        ##R(j) = R(j) + ((y_i' - theta_two'*A_two')*(y_i - A_two*theta_two))
        ##if (i == 69)    %  After we have found the index via R == min(R)
                        ##%  and index_array(25)
            ##theta = [theta_one; theta_two] %Thta gives results
        ##end
        ##index_array(j) = i
        ##j = j+1
    ##else
    ##end
    #i = i + 1;
    #% Need to identify which theta values this solution corresponds to 
#end

# Find variance of three sensors