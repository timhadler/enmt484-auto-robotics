# ENMT482 Assignment One -- Motion model (first part)
# Tim Hadler and Joseph Green, July 2020
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# Load data1 from calibration.csv file
filename = 'training1.csv' # Filename
data1 = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data1

# Load data2 from calibration.csv file
filename = 'training2.csv' # Filename
data2 = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data2

# Split into columns
index1, time1, range_1, velocity_command1, raw_ir1_1, raw_ir2_1, raw_ir3_1, raw_ir4_1, sonar1_1, sonar2_1 = data1.T # Data now segmented

# Split into columns
index2, time2, range_2, velocity_command2, raw_ir1, raw_ir2_2, raw_ir3_2, raw_ir4_2, sonar1_2, sonar2_2 = data2.T # Data now segmented

speed_one = []
speed_one.append(0)

# calculate speed from data
for i in range(0,(len(time1) - 1)):
    speed_one.append((range_1[i + 1] - range_1[i]) / (time1[i + 1] - time1[i]))
    
speed_two = []
speed_two.append(0)

# calculate speed from data
for i in range(0,(len(time2) - 1)):
    speed_two.append((range_2[i + 1] - range_2[i]) / (time2[i + 1] - time2[i]))
    


# Graph measured speed and commanded speed -- Need to estimate the measured speed dx/dt

plt.figure(figsize=(12, 4))

plt.subplot(131)
plt.plot(time1, velocity_command1)
plt.xlabel('Time (s)')
plt.ylabel('Speed')
plt.title('Commanded speed vs time')

plt.subplot(132)
plt.plot(time1, speed_one)
plt.title('Measured speed vs time')
plt.ylabel('Speed')
plt.xlabel('Time (s)')


plt.figure(figsize=(12, 5))

plt.subplot(121)
plt.plot(time2, velocity_command2)
plt.xlabel('Time (s)')
plt.ylabel('Speed')
plt.title('Commanded speed vs time')

plt.subplot(122)
plt.plot(time2, speed_two)
plt.title('Measured speed vs time')
plt.ylabel('Speed')
plt.xlabel('Time (s)')


plt.show()

# Split data into sections so mean speed can be calculated 
# and compared to commanded speed val = [x for x in velocity_command1 if x == 0]
# [1396, 2748, 3319, 3841, 4188, 4438, 4637, 4778]

control_index_one = []
index_count_one = 0
for i in range(0, (len(time1) - 1)):
    if ((velocity_command1[i + 1] >= 0) and (velocity_command1[i] < 0)) or ((velocity_command1[i + 1] <= 0) and (velocity_command1[i] > 0)):
        control_index_one.append(index_count_one)
        index_count_one += 1
    else:
        index_count_one += 1
        
control_index_two = []
index_count_two = 0
for i in range(0, (len(time2) - 1)):
    if ((velocity_command2[i + 1] >= 0) and (velocity_command2[i] < 0)) or ((velocity_command2[i + 1] <= 0) and (velocity_command2[i] > 0)):
        control_index_two.append(index_count_two)
        index_count_two += 1
    else:
        index_count_two += 1
        
# calculate average commanded speed and measured speed for each subset of domain
# as calculated above in control_index

mean_commanded_one = []
i = 0
j = 0 
for x in control_index_one:   
    mean_commanded_one.append(np.average(velocity_command1[range(i,control_index_one[j])]))
    i = control_index_one[j] 
    j = j + 1 # Now need final subset
    
# Results: [0.03884127270872432, -0.04043283515446289, 0.09543305986612204, -0.103362036359496, 0.17309175296310828, -0.24107211297663156, 0.29860297968102667, -0.4208019272132203]
    
speed_one = np.array(speed_one) # [float(speed) for speed in speed_one]

mean_measured_one = []
i = 0
j = 0 
for x in control_index_one:   
    mean_measured_one.append(np.average(speed_one[range(i,control_index_one[j])])) #WTF - non list type???
    i = control_index_one[j] 
    j = j + 1 # Now need final subset    
    
# Results: [0.035467992187437625, -0.03669380073454585, 0.08624772749451541, -0.09316736753835443, 0.1519784252781859, -0.21346742021285958, 0.25910387403305785, -0.367711482168176]

mean_commanded_two = []
i = 0
j = 0 
for x in control_index_two:   
    mean_commanded_two.append(np.average(velocity_command2[range(i,control_index_two[j])]))
    i = control_index_two[j] 
    j = j + 1 # Now need final subset
    
# Results: [0.07602628424613506, 0.09412143882466288, 0.12151137501925383, 0.06754277384669748, 0.0991061365789735, -0.1415233555566618, 0.10315426204593878, 0.10187209545260713, 0.12825800035801627, -0.21097473915991374, 0.1928464180699481, 0.15144731730817754, 0.10498602457173177, -0.18012159986087253, -0.06726639424742434]
    
speed_two = np.array(speed_two) # [float(speed) for speed in speed_one]

mean_measured_two = []
i = 0
j = 0 
for x in control_index_two:   
    mean_measured_two.append(np.average(speed_two[range(i,control_index_two[j])])) #WTF - non list type???
    i = control_index_two[j] 
    j = j + 1 # Now need final subset    
    
# Results [0.04729042765621881, 0.06944104983935306, 0.08897633679182025, 0.044773864398100195, 0.06946582988838636, -0.10544702175316538, 0.0730785010040672, 0.0696628598037675, 0.09562263423422833, -0.17023232879411404, 0.1565053040382783, 0.11887999475643993, 0.07590923845643073, -0.15898599260489993, -0.03972773541905683]

# Combine data from both calibrations into one dataset
mean_commanded_combined = mean_commanded_one + mean_commanded_two
mean_measured_combined = mean_measured_one + mean_measured_two

# Plot commanded vs. measured for motion model
plt.figure(figsize=(12, 4))

plt.subplot(131)
plt.plot(mean_commanded_combined, mean_measured_combined)
plt.xlabel('Commanded speed')
plt.ylabel('Measured Speed')
plt.title('Commanded vs Measured Speed')

plt.show()