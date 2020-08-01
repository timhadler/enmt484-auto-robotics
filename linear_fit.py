# ENMT482 Assignment One -- linear fit program for sonar sensors (first part)
# Tim Hadler and Joseph Green, July 2020
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# Load data from calibration.csv file
filename = 'calibration.csv' # Filename
data = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data

# Split into columns
index, time, range_1, velocity_command, raw_ir1, raw_ir2, raw_ir3, raw_ir4, sonar1, sonar2 = data.T # Data now segmented

# x and y data
x = time
y = sonar2

# Reject outliers in data
boolArr1 = abs(sonar2 - np.mean(sonar2)) < 2 * np.std(sonar2)
y = sonar2[boolArr1]
x = time[boolArr1]

x = np.array(x)
y = np.array(y)
n = len(x)
gradient = (n*sum(np.transpose(x)*y) - sum(x)*sum(y)) / (n*sum(np.transpose(x)*x) - sum(x)*sum(x))
intercept = (sum(y)- gradient*sum(x)) / n

X = np.linspace(0.03, 200)
F1 = ((gradient * X) + intercept)

plt.figure(figsize=(8, 7))

plt.subplot(222)
plt.plot(x, y, '.', alpha=0.5)
plt.plot(X, F1, color = "red")
plt.title('IR1 with outliers')
plt.ylabel('Measurement (V)')
plt.show()