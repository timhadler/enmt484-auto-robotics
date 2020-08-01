# ENMT482 Assignment One -- best fit (first part)
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

# Function to fit to data -- returned 0.24402291 for a only raw_ir1
def f_model(x, a, b, c):
    return (a / (b * (x**c)))

# Function to fit non-linear curve to data
popt, pcov = curve_fit(
    f=f_model,       # model function
    xdata=time,   # x data
    ydata=np.array(raw_ir1),   # y data
    p0=(0.24402291, -2, 2),      # initial value of the parameters
)
print(popt)