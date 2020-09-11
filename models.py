"""Particle filter demonstration program.
Joseph Green and Tim Hadler, Sept 2020 -- ENMT482
Based on code by:
M.P. Hayes and M.J. Edwards,
Department of Electrical and Computer Engineering
University of Canterbury
"""

import numpy as np
from numpy import cos, sin, tan, arccos, arcsin, arctan2, sqrt, exp
from numpy.random import randn
from utils import gauss, wraptopi, angle_difference
import math
import random
from transform import *


def motion_model(particle_poses, speed_command, odom_pose, odom_pose_prev, dt):
    """Apply motion model and return updated array of particle_poses.

    Parameters
    ----------

    particle_poses: an M x 3 array of particle_poses where M is the
    number of particles.  Each pose is (x, y, theta) where x and y are
    in metres and theta is in radians.

    speed_command: a two element array of the current commanded speed
    vector, (v, omega), where v is the forward speed in m/s and omega
    is the angular speed in rad/s.

    odom_pose: the current local odometry pose (x, y, theta).

    odom_pose_prev: the previous local odometry pose (x, y, theta).

    dt is the time step (s).

    Returns
    -------
    An M x 3 array of updated particle_poses.

    """
    
    M = particle_poses.shape[0]
    
    # TODO.  For each particle calculate its predicted pose plus some
    # additive error to represent the process noise.  With this demo
    # code, the particles move in the -y direction with some Gaussian
    # additive noise in the x direction.  Hint, to start with do not
    # add much noise.

    for m in range(M):
        ## Iterate through particles 
        # Add random noise to each position measurement
        particle_poses[m, 0] += randn(1) * 0.005
        particle_poses[m, 1] += randn(1) * 0.005
        particle_poses[m, 2] += randn(1) * 0.005
        
        # update particle pose rotations
        distance = math.sqrt(((odom_pose[0] - odom_pose_prev[0])**2) + ((odom_pose[1] - odom_pose_prev[1])**2))
        rot1 = math.atan2(odom_pose[1] - odom_pose_prev[1], odom_pose[0] - odom_pose_prev[0]) - odom_pose_prev[2]    
        rot2 = odom_pose[2] - odom_pose_prev[2] - rot1
        
        # Perform rotation 1, translation and rotation 2
        #particle_poses[m, 2] = rot1 
        particle_poses[m, 0] += distance * math.cos(odom_pose_prev[2] + rot1)
        particle_poses[m, 1] += distance * math.sin(odom_pose_prev[2] + rot1) #odom_pose[1] - odom_pose_prev[1]
        particle_poses[m, 2] += wrapto2pi(rot1 + rot2) # math.atan2(odom_pose[1] - odom_pose_prev[1], odom_pose[0] - odom_pose_prev[0]) - odom_pose_prev[2]
    
    return particle_poses

def sensor_model(particle_poses, beacon_pose, beacon_loc):
    """Apply sensor model and return particle weights.

    Parameters
    ----------
    
    particle_poses: an M x 3 array of particle_poses (in the map
    coordinate system) where M is the number of particles.  Each pose
    is (x, y, theta) where x and y are in metres and theta is in
    radians.

    beacon_pose: the measured pose of the beacon (x, y, theta) in the
    robot's camera coordinate system.

    beacon_loc: the pose of the currently visible beacon (x, y, theta)
    in the map coordinate system.

    Returns
    -------
    An M element array of particle weights.  The weights do not need to be
    normalised.

    """

    M = particle_poses.shape[0]
    particle_weights = np.zeros(M)
    dist_list = []
    angle_list = []
    
    # TODO.  For each particle calculate its weight based on its pose,
    # the relative beacon pose, and the beacon location.
    
    # Code for beacon pose in the map coordinate system    
    
    for m in range(M):      
        # Find transpose between particle_poses[m,:] and beacon_pose
        # odom_to_map = find_transform(odom_poses[0], slam_poses[0])
        #beacon_to_particle = find_transform(beacon_pose, particle_poses[m,:])
        particle_beacon_location = transform_pose(particle_poses[m,:], beacon_pose)
        
        # Find difference in distance and angle from particle to beacon in
        # particle frame
        diff_x_one = particle_beacon_location[0] - particle_poses[m,0]
        diff_y_one = particle_beacon_location[1] - particle_poses[m,1]
        dist_diff_one = math.sqrt(((diff_x_one) ** 2) + ((diff_y_one) ** 2))
        angle_diff_one = particle_beacon_location[2] - particle_poses[m,2] 
        wraptopi(angle_diff_one) 
        
        # Find difference in distance and angle between particle and
        # actual beacon location
        diff_x_two = beacon_loc[0] - particle_poses[m,0]
        diff_y_two = beacon_loc[1] - particle_poses[m,1]
        dist_diff_two = math.sqrt(((diff_x_two) ** 2) + ((diff_y_two) ** 2))
        angle_diff_two = beacon_loc[2] - particle_poses[m,2]
        wraptopi(angle_diff_two) 
        
        
        dist_list.append(dist_diff_one - dist_diff_two)
        angle_list.append(angle_diff_one - angle_diff_two)
        
        # Find averages and variances
        std_dist = np.std(dist_list)
        std_angle = np.std(angle_list)
        mean_dist = np.mean(dist_list)
        mean_angle = np.mean(angle_list)
        
        # Find Gaussians
        gauss_dist = gauss(dist_list[m], mean_dist, std_dist)
        gauss_angle = gauss(angle_list[m], mean_angle, std_angle)
        
        #Form Gaussian
        # particle_weights[m] = (gauss_dist) * (gauss_angle)
        particle_weights[m] = (dist_diff_two - dist_diff_one) * (angle_diff_two - angle_diff_one)
        #particle_weights[m] = 1
        
        # Return weights
    return particle_weights 