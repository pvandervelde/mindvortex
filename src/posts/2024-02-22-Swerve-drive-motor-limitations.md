Title: Swerve drive - Motor limitations
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

The [swerve controller](/posts/Swerve-drive-kinematics-simulation) I have implemented so far assumes
that the robot is able to follow all the movement commands it has been given. This leads to extreme
velocity and acceleration for the drive and steering motors. The image below shows the result of a
simulation where the robot is commanded to move in a straight line followed by a rotate in-place. The
simulation used a s-curve [motion profile](/posts/Swerve-motion-profiles) to generate a smooth movement
between different states. The graphs show that the drive velocity and acceleration are smooth and
don't reach very high values. It is thus expected that these are well within the capabilities of the
drive motors. The steering velocity and acceleration show significant peaks which are likely to tax
the steering motors.

<figure style="float:left">
  <a href="/assets/images/robotics/control/inplace_rotation_from_0_fwd_unlimited.png" target="_blank">
    <img
        alt="The positions, velocities and accelerations of the robot and the drive modules as it moves in a straight line and then rotates in place with no limiters applied."
        src="/assets/images/robotics/control/inplace_rotation_from_0_fwd_unlimited.png"
        width="416"
        height="200"/>
  </a>
  <figcaption>
    The positions, velocities and accelerations of the robot and the drive modules as it moves in a
    straight line and then rotates in place. No limitations were applied to the steering and drive
    velocities and accelerations.
  </figcaption>
</figure>

In order to ensure that the motors are able to follow the movement commands while keeping the motions
of the different drive modules [synchronised](/posts/Swerve-drive-body-focussed-control), we need to
take into account the capabilities of the motors.

Now there are many different motor characteristics that we could take into account. For instance:

- The maximum velocity the motor can achieve. This obviously limits how fast the drive module can steer
  or rotate the wheels.
- The existence of any motor [deadband](https://en.wikipedia.org/wiki/Deadband). This is the region
  around zero rotation speed where the motor doesn't have enough torque to overcome the static
  friction of the motor and attached systems. Once enough torque is applied the motor will start
  running at the rotation speed that it would normally have for that amount of torque. This means that
  there is a minimum rotation speed that the motor can achieve.
- The behaviour of the motor under load. For instance the motor may not be able to reach the desired
  rotation speed under load.
- The motor settling time, which is the time it takes the motor to reach the commanded speed.
- The motor behaves differently when running 'forwards' than it does when running 'backwards'. For
  instance the motor may have a different maximum velocity in the two directions.

At the moment I will only be looking at the maximum motor velocities and the accelerations. These two
have a direct effect on the synchronisation between the drive modules. The other characteristics will
be dealt at a later stage as they require more information and thought.

In order to limit the steering and drive velocities I've implemented the following process

1. [Determine](https://github.com/pvandervelde/basic-swerve-sim/blob/d6c8349b7f184c85ac77fa8b19298bb79e22cebf/swerve_controller/control_profile.py#L612)
   the body movement profile that allows the body to achieve the desired movement state in
   a smooth manner using [s-curve motion profiles](/posts/Swerve-motion-profiles).
1. Divide the body movement profiles into N+1 points, dividing the profile into N sections of equal
   time. For each of these points
   [calculate the velocity and steering angle](https://github.com/pvandervelde/basic-swerve-sim/blob/d6c8349b7f184c85ac77fa8b19298bb79e22cebf/swerve_controller/control_profile.py#L635)
   for the drive modules. These velocities and steering angles then form the motion profiles for each
   of the drive modules.
1. For each point in time check the steering velocity for each module. Record the maximum velocity of
   all the profiles. If the maximum velocity is larger than what the motor can deliver then
   [increase or decrease the current timestep](https://github.com/pvandervelde/basic-swerve-sim/blob/d6c8349b7f184c85ac77fa8b19298bb79e22cebf/swerve_controller/control_profile.py#L414)
   in order to limit the steering velocity to the maximum velocity of the motor. Changing the
   duration of the timestep will change the steering velocities of all the modules. Thus we limit
   the steering velocities while maintaining synchronisation between the modules.
1. Repeat the previous step for the [drive velocities](https://github.com/pvandervelde/basic-swerve-sim/blob/d6c8349b7f184c85ac77fa8b19298bb79e22cebf/swerve_controller/control_profile.py#L546).

The following video shows the result of the simulation using the new velocity limiter code. The video
shows the robot moving in a straight line and then rotating in place. When the rotation starts the
steering velocity for the different drive modules increases. As the steering velocity reaches 2 rad/s
for the left front and left rear modules the limiter kicks in and maintains that steering velocity.
In response the steering velocities of the other wheels reduces in order to keep the drive modules
synchronised. The wheel velocities are slightly altered.

<iframe
    style="float:none"
    width="560"
    height="315"
    src="https://www.youtube.com/embed/H7HTa4b6f_0"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
</iframe>

With the steering and wheel velocities limited in a reasonable way I attempted to do the same for the
steering acceleration. The results of this can be seen in the next images. The first image limits the
steering acceleration to 15 rad/s^2. The second image limits the steering acceleration to 10 rad/s^2.

<figure style="float:left">
  <a href="/assets/images/robotics/control/inplace_rotation_from_0_fwd_acc_limited_15_rad_s2.png" target="_blank">
    <img
        alt="The positions, velocities and accelerations of the robot and the drive modules as it moves in a straight line and then rotates in place. Limits are applied to the velocities and the steering acceleration."
        src="/assets/images/robotics/control/inplace_rotation_from_0_fwd_acc_limited_15_rad_s2.png"
        width="416"
        height="200"/>
  </a>
  <figcaption>
    The positions, velocities and accelerations of the robot and the drive modules as it moves in a
    straight line and then rotates in place. The steering velocity is limited to 2 rad/s, the drive
    velocity is limited to 1.0 m/2 and the steering acceleration is limited to 15 rad/s^2.
  </figcaption>
</figure>

<figure style="float:left">
  <a href="/assets/images/robotics/control/inplace_rotation_from_0_fwd_acc_limited_10_rad_s2.png" target="_blank">
    <img
        alt="The positions, velocities and accelerations of the robot and the drive modules as it moves in a straight line and then rotates in place. Limits are applied to the velocities and the steering acceleration."
        src="/assets/images/robotics/control/inplace_rotation_from_0_fwd_acc_limited_10_rad_s2.png"
        width="416"
        height="200"/>
  </a>
  <figcaption>
    The positions, velocities and accelerations of the robot and the drive modules as it moves in a
    straight line and then rotates in place. The steering velocity is limited to 2 rad/s, the drive
    velocity is limited to 1.0 m/2 and the steering acceleration is limited to 10 rad/s^2.
  </figcaption>
</figure>

When comparing the two simulation results it becomes clear that something happens if we limit the
steering acceleration to 10 rad/s^2. The velocities over all for both cases looks reasonable, except
for the 10 rad/s^2 case where the steering velocity snaps to zero at the end of the transition from
the straight line to the rotation. This is reflected in a momentary acceleration of over 100 rad/s^2.

The acceleration is calculated based on the difference between the velocity at the current timestep
and the velocity at the previous timestep. Additionally the algorithm has to ensure that the steering
angle change between the previous and current timestep is controlled so that synchronisation of the
drive modules is maintained. Generally to limit the velocity the duration of the timestep is increased.
However for the acceleration, especially when decelerating from a positive velocity, there is a limit
to how much the timestep can be increased. A larger time step increase decreases the velocity. This
then increases the deceleration needed. So this means that you get very large timesteps, or very small
timesteps. The current algorithm favours small timesteps.

In either case the problem occurs when slowing down. At the end of the deceleration profile the desired
position is achieved, but the velocity and acceleration are not zero. This is not realistic or physically
possible. This behaviour is possibly due to the fact that the timesteps are individually calculated.
This means that the algorithm doesn't know what the desired end states are and so those are not taken
into account.

Additionally if we look at this approach from a higher level we can see that there are two potential
areas where improvements can be made in the control model. The first area is related to the fact that
the steering velocity and acceleration are computed values, i.e. they are derived from the change in
the steering position. This means that there is no direct control over the steering velocity and
acceleration. A better algorithm would include these values directly and be able to apply boundary
conditions on these values. This could be achieved by extending the current kinematic model with the
body accelerations and [jerks](https://en.wikipedia.org/wiki/Jerk_(physics)).
The second area is related tot the fact that the module states are derived from the body state. This
is necessary to keep the modules synchronised with the body. However this means that the module states
are not directly controlled. Which means that it is more difficult to include the module limitations
in the control model.

These issues will only become more pronounced if we want to start limiting the with the maximum jerk
values for the steering and drive directions. Limiting the maximum jerk is required to prevent excessive
forces on the drive modules and the body.

One possible solution to these issues is to switch to a dynamic model. This would allow for the inclusion
of the body accelerations and jerks. Additionally the dynamic model would allow for the inclusion of
the behaviour of the steering modules more directly and thus lead to a more accurate control model.
However the dynamic model is more complex and requires more information. Dynamic models are easier to
extend to 3 dimensions, which is required if we want the robot to be able to move around on uneven
non-horizontal terrain.
