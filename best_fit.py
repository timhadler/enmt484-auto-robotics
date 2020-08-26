# ENMT482 Assignment One -- Sensor Fusion (first part)
# Tim Hadler and Joseph Green, July 2020
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#from scipy import ndimage, misc

# Load data from calibration.csv file
filename = 'calibration.csv' # Filename
data = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data

# Split into columns
index, time, range_1, velocity_command, raw_ir1, raw_ir2, raw_ir3, raw_ir4, sonar1, sonar2 = data.T # Data now segmented

# Function to fit to data -- returned 0.24402291 for a only raw_ir1
def f_model(x, a, b, c):
    return (a / (b*(x**c)))

# Function to fit non-linear curve to data
popt, pcov = curve_fit(
    f=f_model,       # model function
    xdata=time,   # x data
    ydata=np.array(raw_ir1),   # y data
    p0=(0.24402291, 2, 3),      # initial value of the parameters
)
print(popt)


#Plot best fit
#fig, ax = plt.subplots()
#ax.axis([0, 200, 0, 2.5])
#plt.plot(time, raw_ir1, '.', alpha=0.5) 
#X = np.linspace(0.3, 200)
#F1 = -5.22438450e+02 / (-3.48823283e+02*(X**3.49538136e-01))
#ax.plot(X, F1)
#plt.show()

# Best fit for raw_ir1 (or raw_ir2)
fig, ax = plt.subplots()
ax.axis([0, 200, 0, 2.5])
plt.plot(time, raw_ir2, '.', alpha=0.6) 
X = np.linspace(0.3, 200)
F1 = 10 / (X)
ax.plot(X, F1)
plt.show()

#Play around with best fit for raw_ir3
fig, ax = plt.subplots()
ax.axis([0, 200, 0, 2.5])
plt.plot(time, raw_ir3, '.', alpha=0.6) 
X = np.linspace(0.3, 200)
F1 = 600 / (50 * (X**0.8))
ax.plot(X, F1)
plt.show()

boolArr1 = abs(raw_ir1 - np.mean(raw_ir1)) < 4 * np.std(raw_ir1)
raw_ir1_without = raw_ir1[boolArr1]
time_1 = time[boolArr1]

def f_model(x, a, b, c):
    return (a / (b*(x**c)))

# Function to fit non-linear curve to data
popt, pcov = curve_fit(
    f=f_model,       # model function
    xdata=time,   # x data
    ydata=np.array(raw_ir3),   # y data
    p0=(0.24402291, 2, 3),      # initial value of the parameters
)
print(popt)

#Plot best fit without outliers
#fig, ax = plt.subplots()
#ax.axis([0, 200, 0, 2.5])
#plt.plot(time_1, raw_ir1_without, '.', alpha=0.5) 
#X = np.linspace(0.3, 200)
#F1 = 223.24727436 / (152.32440093*(X**0.34670224))
#ax.plot(X, F1)
#plt.show()

