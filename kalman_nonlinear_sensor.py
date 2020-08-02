# ENMT482 Assignment One -- non-linear kalman filter for one sensor (first part)
# Tim Hadler and Joseph Green, Aug 2020
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

# Initial position 
x = 0

# Sensor numerator
a = 0.24402291

# Speed 
v = 0.02

# Number of steps and time-step interval
Nsteps = 3023
dt = 0.06

# Process and sensor noise standard deviations - need to determine from model
std_W=0.2*dt
std_V = 0.1

# Process and measurement noise variances
var_W = std_W ** 2
var_V = std_V ** 2

# Motion with additive process noise
z = raw_ir1
#x= zeros(Nsteps)
#z = zeros(Nsteps)
#for n in range(1, Nsteps):
    ## Update simulated robot position
    #x[n]=x[n-1]+v*dt+randn(1)*std_W
    ## Simulate measured range with additive sensor noise
    #z[n] = x[n] + randn(1) * std_V
    
# Start with a poor initial estimate of robot’s position
mean_X_posterior = 10
var_X_posterior = 10 ** 2

# Kalman filter
for n in range(1, Nsteps):
    # Calculate mean and variance of prior estimate for position
    # (using motion model)
    mean_X_prior = mean_X_posterior + v * dt
    var_X_prior = var_X_posterior + var_W
    
    # ML estimate of position from measurement (using sensor model)    
    x_infer = (z[n] - 2*(a / mean_X_prior))*(mean_X_prior**2 / (-a))
    
    # Calculate Kalman gain
    K = var_X_prior / (var_V + var_X_prior)
    
    # Calculate mean and variance of posterior estimate for position
    mean_X_posterior = mean_X_prior + K * (x_infer - mean_X_prior)
    var_X_posterior = (1 - K) * var_X_prior