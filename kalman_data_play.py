# ENMT482 Assignment One -- non-linear kalman filter for one sensor (first part)
# Tim Hadler and Joseph Green, Aug 2020
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# Load data from calibration.csv file
filename = 'training2.csv' # Filename
data = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data

# Split into columns
index, time, range_, velocity_command, raw_ir1, raw_ir2, raw_ir3, raw_ir4, sonar1, sonar2 = data.T # Data now segmented

# Initial position 
x = 0

# Commanded Speed 
v = velocity_command

# Number of steps and time-step interval
Nsteps = len(time)

# Process and sensor noise standard deviations - need to determine from model
# using sonar2
std_W = 0.0018 # * dt
std_V = 0.288

# Process and measurement noise variances
var_W = std_W ** 2
var_V = std_V ** 2

# Sensor and motion model linear coefficients
sensor_grad = 0.6300333587330464
sensor_inter = 0.8529724004308606

motion_grad = 0.8378336109383506
motion_inter = -0.0049023257494812305

# z is sonar value
z = sonar2
    
# Start with a poor initial estimate of robot’s position
mean_X_posterior = 0.10288
var_X_posterior = 0.0018 ** 2

# Kalman filter
for n in range(2, Nsteps): #Nsteps
    # Calculate current time increment
    dt = time[n] - time[n - 1]
    
    # Calculate mean and variance of prior estimate for position
    # (using motion model)
    mean_X_prior = mean_X_posterior + ((motion_grad*v[n]) * dt) + motion_inter
    var_X_prior = var_X_posterior + var_W
    
    # ML estimate of position from measurement (using sensor2 model)    
    x_infer = ((z[n] - sensor_inter) / sensor_grad)
    # For non-linear
    #x_infer = (z[n] - 2*(a / mean_X_prior))*(mean_X_prior**2 / (-a))
    
    # Calculate Kalman gain
    K = ((1 / var_X_posterior) / ((1 / var_X_prior) + (1 / var_X_posterior)))
    
    # Calculate mean and variance of posterior estimate for position
    mean_X_posterior = mean_X_prior + K * (x_infer - mean_X_prior)
    var_X_posterior = 1 / ((1 / var_V) + (1 / var_X_prior))