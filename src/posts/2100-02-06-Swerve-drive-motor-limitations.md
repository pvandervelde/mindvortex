Title: Swerve drive - Motor limitations
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

- The simulations so far have assumed that we can make all the movements we want to make. Especially with respect to the
  capabilities of the drive and steering motor. In reality these motors have limitations in terms of rotational velocity,
  acceleration and torque.
- Take into account the motor limitations, because this has an effect on our motions and possibly on the synchronisation
  between the drive modules

- Implemented limitations for the steering motor and the drive motor in terms of
    + Max velocity (+/-)
    + Max acceleration

- Assume that the motors have equal maximum speeds in both clock-wise and counter clock-wise direction
- We will deal with the steering velocity / acceleration first and then do the drive velocity / acceleration, because
  changing the steering velocity / acceleration will have an effect on the drive velocity / acceleration, but not
  necessarily the other way around. As long as the drive velocity ratios between the modules are maintained, the
  steering angle isn't affected while keeping the modules synchronised.

- Created the motion profile for all 4 modules based on the desired body movement
    + Create the body movement profile (x, y, theta)
    + Divide the body movement profiles into N+1 points, dividing the profile into N sections of equal time
    + for each point calculate the state for the drive modules (velocity, steering angle)
    + Use the calculated points to create a motion profile for each module
    + For each point in time check the steering velocity for each module. Record the maximum velocity of all the profiles
    + If the maximum velocity is larger than what the motor can deliver then calculate the time duration of the current
      timestep in order to limit the steering velocity to the maximum velocity of the motor (generally increases the
      duration of the timestep). Increasing the duration of the timestep will reduce the velocity magnitudes of all the
      module profiles. This should limit the steering velocity to the maximum velocity of the motor.
    + NEXT IS STEERING ACCELERATION
    + NEXT IS DRIVE VELOCITY

- Issues with this approach
    + Max velocity is relatively easy. Changing the timestep duration will limit the velocity to the maximum velocity
      of the motor. NOTE: This will also limit the acceleration, because the acceleration is calculated based on the
      difference between the current velocity and the previous velocity. If the current velocity is limited to the
      maximum velocity of the motor, then the acceleration will also be limited to the maximum acceleration of the
      motor.
    + Max acceleration is more difficult. The acceleration is calculated based on the difference between the current
      velocity and the previous velocity. We want to keep the steering angle change between the previous and
      current timestep constant. Generally to limit the velocity we increase the duration of the timestep. However for
      the acceleration, especially when decelerating from a positive velocity, we are limited to how much we can increase
      the timestep. A larger time step increase decreases the velocity. This then increases the deceleration needed. So
      this means that you get very large timesteps, or very small timesteps. That is not necessarily a problem, but it
      can lead to the fact that the velocity / acceleration won't get to zero at the end of the profile. Obviously
      this is not realistic (or physically possible).
    + This problem will only get more pronounced when we want to deal with the steering motor maximum jerk.
    + This issue is probably due to the fact that:
        - We use a kinematic approach (deal with velocities and angles), not a dynamic one (deal with forces and accelerations)
        - We apply the commands to the body and thus indirectly to the modules in order to keep things synchronized
- This



- Show video's for different profiles for the motion of driving straight and then going into a rotation


- For later
    + Max jerk
    + Deadband
    + Torque vs rotation speed
    + Response time

