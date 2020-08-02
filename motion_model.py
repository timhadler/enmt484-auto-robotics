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
index1, time1, range_1_1, velocity_command1, raw_ir1_1, raw_ir2_1, raw_ir3_1, raw_ir4_1, sonar1_1, sonar2_1 = data1.T # Data now segmented

# Split into columns
index2, time2, range_1_2, velocity_command2, raw_ir1_2, raw_ir2_2, raw_ir3_2, raw_ir4_2, sonar1_2, sonar2_2 = data2.T # Data now segmented

plt.figure(figsize=(8, 7))

plt.subplot(221)
plt.plot(time1, velocity_command1, '.', alpha=0.5) #raw_ir1_without,time_1
plt.title('Commanded velocity training 1')
plt.ylabel('Measurement (V)')

plt.subplot(222)
plt.plot(time2, velocity_command2, '.', alpha=0.5) #raw_ir1_without,time_1
plt.title('Commanded velocity training 2')
plt.ylabel('Measurement (V)')
plt.show()