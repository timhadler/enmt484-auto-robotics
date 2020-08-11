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
index1, time1, range_1, velocity_command1, raw_ir1, raw_ir2_1, raw_ir3_1, raw_ir4_1, sonar1_1, sonar2_1 = data1.T # Data now segmented

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