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

speed = []
speed.append(0)

# calculate speed from data
for i in range(0,(len(time1) - 1)):
    speed.append((range_1[i + 1] - range_1[i]) / (time1[i + 1] - time1[i]))

# Graph measured speed and commanded speed -- Need to estimate the measured speed dx/dt

plt.figure(figsize=(12, 4))

plt.subplot(131)
plt.plot(time1, velocity_command1)
plt.xlabel('Time (s)')
plt.ylabel('Speed')
plt.title('Commanded speed vs time')

plt.subplot(132)
plt.plot(time1, speed)
plt.title('Measured speed vs time')
plt.ylabel('Speed')
plt.xlabel('Time (s)')
plt.show()