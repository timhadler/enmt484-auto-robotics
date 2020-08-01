# ENMT482 Assignment One -- linear least squares fit program for sonar sensors (first part)
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

# test data -- should give 3.9112 and -1.9498
#x = [0.607695308931057, 0.718042017737467, 0.770431605575690, 0.878443409566275, 0.954519241323483, 1.11063070873691, 1.10032984608548, 1.27275593304618, 1.26377106965592, 1.34140125800421]
#y = [0.328382373803627, 0.740009483795220, 1.20737730606433, 1.49183197399759, 2.00511677195437, 2.15620600786244, 2.49088470178010, 2.86805262526571, 3.10338021099341, 3.29330487242852]

x = time
y = sonar2
x = np.array(x)
y = np.array(y)
n = len(x)
gradient = (n*sum(np.transpose(x)*y) - sum(x)*sum(y)) / (n*sum(np.transpose(x)*x) - sum(x)*sum(x))
intercept = (sum(y)- gradient*sum(x)) / n

#Plot best fit
fig, ax = plt.subplots()
ax.axis([0, 200, 0, 2.5])
X = np.linspace(0, 200)
F1 = gradient*X + intercept
ax.plot(X, F1, time, sonar1)
plt.show()