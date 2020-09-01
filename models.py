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
        # Add random noise to each position measurement
        particle_poses[m, 0] += randn(1) * 0.1
        particle_poses[m, 1] += randn(1) * 0.1
        particle_poses[m, 2] += randn(1) * 0.1
        
        # update particle poses
        rot1 = math.atan2(odom_pose[1] - odom_pose_prev[1], odom_pose[0] - odom_pose_prev[0]) - odom_pose_prev[2]
        trans = math.sqrt(((odom_pose_prev[0] - odom_pose[0])**2) + ((odom_pose_prev[1] - odom_pose[1])**2))
        rot2 = odom_pose[2] - odom_pose_prev[2] - rot1
        
        #trans_commanded = speed_command[0] * dt
        #rot_commanded = speed_command[1] * dt

        # Update pose
        particle_poses[m, 0] += odom_pose[0] - odom_pose_prev[0]
        particle_poses[m, 1] += odom_pose[1] - odom_pose_prev[1]
        particle_poses[m, 2] += rot2
        
        #particle_poses[m, 1] -= 0.1
    
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
    
    # TODO.  For each particle calculate its weight based on its pose,
    # the relative beacon pose, and the beacon location.
    
    # Code for beacon pose in the map coordinate system

    for m in range(M):
        
        beacon_map_x = ((beacon_pose[0]) * math.cos(abs(particle_poses[m, 2] - beacon_pose[2]))) - ((beacon_pose[1]) * math.sin(abs(particle_poses[m, 2] - beacon_pose[2]))) + (beacon_pose[0] - particle_poses[m, 0])
        beacon_map_y = ((beacon_pose[1]) * math.cos(abs(particle_poses[m, 2] - beacon_pose[2]))) + ((beacon_pose[0]) * math.sin(abs(particle_poses[m, 2] - beacon_pose[2]))) + (beacon_pose[1] - particle_poses[m, 1])
        beacon_map_theta = beacon_pose[2] + abs(particle_poses[m, 2] - beacon_pose[2])        
        
        # Apply particle weights
        particle_weights[m] = math.sqrt((beacon_map_x ** 2) + (beacon_map_y ** 2))

    return particle_weights
