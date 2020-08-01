# Based on Kalman filter demonstration program to estimate M.P. Hayes UCECE 2015
# position of a robot moving at constant speed.
# Tim Hadler and Joseph Green, Aug 2020

# Initial position 
x = 0

# Speed 
v = 0.02

# Number of steps and time-step interval
Nsteps = 3023
dt = 0.06

# Process and sensor noise standard deviations go here - need to determine from model

# Process and measurement noise variances go here - need to determine

# z[n] is the robots position below

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
    x_infer = z[n]
    
    # Calculate Kalman gain
    K = var_X_prior / (var_V + var_X_prior)
    
    # Calculate mean and variance of posterior estimate for position
    mean_X_posterior = mean_X_prior + K * (x_infer - mean_X_prior)
    var_X_posterior = (1 - K) * var_X_prior