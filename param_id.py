# ENMT482 Assignment One -- Param ID from ENME403 (first part)
# Tim Hadler and Joseph Green
# Ensure calibration.csv is in the same DIR as this program and the env path is:
# !/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import csv

# Load data from calibration.csv file
#filename = 'calibration.csv' # Filename
# Load data from calibration.csv file
filename = 'ex_five.csv' # Filename
data = np.loadtxt(filename, delimiter=',', skiprows=1) # Get data

# Split into columns
index, x, y = data.T # Data now segmented

# Split into columns
#index, time, range_1, velocity_command, raw_ir1, raw_ir2, raw_ir3, raw_ir4, sonar1, sonar2 = data.T #Data now segmented

# Find elastic and plastic region for IR1
i = 5
j = 0
n = len(x)
R = []
index_array = []
while (i < (n - 4)):
    x_b = x[i];
    A_one = np.transpose(np.array([np.ones(len(x[0:i])), x[0:i]]))
    theta_one = np.matmul(((np.linalg.inv(np.matmul(np.transpose(A_one),A_one)))),np.matmul(np.transpose(A_one),y[0:i])) # Pick up here
    A_two = np.transpose([np.ones(len(x[(i -1):])), x[(i - 1):]]) # Don't doubel up here
    theta_two = np.matmul(np.matmul((np.linalg.inv((np.matmul(np.transpose(A_two),A_two)))),np.transpose(A_two)),y[(i - 1):])
    y_i = y[(i - 1):]
    x_last = x[i-2] < x[i-1]
    x_next = x[i-1] < x[i]
    if (((x_last) and (x_next)) and (theta_one[1] != theta_two[1])):
        R.append(np.matmul((np.transpose(y[0:i]) - np.matmul(np.transpose(theta_one),np.transpose(A_one))),(y[0:i] - np.matmul(A_one,theta_one))))
        R[j] = R[j] + (np.matmul((np.transpose(y_i) - np.matmul(np.transpose(theta_two),np.transpose(A_two))),(y_i - np.matmul(A_two,theta_two)))) #here
        if (i == 31):    #  After we have found the index via R == min(R)
                        #  and index_array(25)
            theta = [theta_one, theta_two] #Thta gives results
        index_array.append(i)
        j = j+1 #think about removing this
    i = i + 1;
    # Need to identify which theta values this solution corresponds to 
