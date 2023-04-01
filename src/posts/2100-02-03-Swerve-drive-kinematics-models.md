Title: Swerve drive - Kinematics models
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

As I explained in an [earlier post](posts/Swerve-drive-kinematics-simulation) I have written some
code to simulate the movement of a four wheel swerve drive. Before I can start using this code I will
need to make sure my code is actually producing the correct results. The
[verification](https://en.wikipedia.org/wiki/Software_verification_and_validation) is  done by
running a bunch of simple simulations for which I am able to predict the behaviour using some
simple maths.

As a reminder the image below shows the different degrees of freedom for the swerve drive as well as
the coordinate systems for the different parts.

<figure style="float:left">
  <a href="/assets/images/robotics/swerve/swerve-dof.png" target="_blank">
    <img alt="Swerve drive degrees of freedom" src="/assets/images/robotics/swerve/swerve-dof.png" />
  </a>
  <figcaption>Degrees of freedom for a swerve drive system.</figcaption>
</figure>


To verify that my code is correct I a ran a number of sets of verifications. The first set is used
to ensure that both the positive and the negative direction behaviour for the main axis directions.
Any differences in behaviour between the positive and the negative direction point to issues in the
simulation code. So the simulations that were done for this verification set are:

- Drive the robot in x-direction while facing in the x-direction, one simulation going forward from
  the origin and one simulation going backwards from the origin.
- Drive the robot in the y-direction while facing in the x-direction, one simulation going left from
  the origin and one simulation going right from the origin.
- Drive the robot in a rotation only movement, one simulation going clockwise and one simulation going
  counter-clockwise.

The second simulation set is designed to verify the coordinate calculations related to rotations. The
simulations that were done for this verification set are:

- Rotate the robot by 90 degrees and then drive it in the robot x-direction. One set of simulations
  for a clockwise 90 degree rotation, driving forwards and backwards. A second set of simulations
  for a counter-clockwise 90 degree rotation, again driving forwards and backwards.
- Rotate the robot by 90 degrees and then drive it in the robot y-direction. One set of simulations
  for a clockwise 90 degree rotation, driving left and right. A second set of simulations
  for a counter-clockwise 90 degree rotation, again driving left and right.
- Rotate the robot by 180 degrees and then drive it in the robot x-direction. One set of simulations
  for a clockwise 180 degree rotation, driving forwards and backwards. A second set of simulations
  for a counter-clockwise 180 degree rotation, again driving forwards and backwards.
- Rotate the robot by 180 degrees and then drive it in the robot y-direction. One set of simulations
  for a clockwise 180 degree rotation, driving left and right. A second set of simulations
  for a counter-clockwise 180 degree rotation, again driving left and right.

The third set of simulations is designed to verify the behaviour during combined movements. The
simulations that were done for this verification set are:











- Drive the robot diagonally (45, 135, 225, 315) while facing in the x-direction
- Drive the robot diagonally (45, 135, 225, 315) while facing in the y-direction

- Diagonal at (30, 60, 120, 150, 210, 240, 300, 330) -> offset the x, y relation

- Forward + rotation, X + rotation
- Sideways + rotation, Y + rotation
- Diagonal + rotation


The bits of the code that need to be tested are the algorithm used to determine the drive module
behaviour. The second thing is the controller. And the third part is the trajectory code.

- We use trajectory code to move from one state (x_vel, y_vel, rot_vel) to another. The trajectory
  might be a linear one, but we specifically want trajectories so that we can alter them to something
  that is not linear

- Currently implementing a [simple kinematics approach](https://www.chiefdelphi.com/t/paper-4-wheel-independent-drive-independent-steering-swerve/107383).


SHOW DIAGRAM OF THE MODEL

- Explain math for forward and inverse kinematics

Equations:

    v_i = v + W x r_i

    alpha = acos (v_i_x / |v_i|)
          = asin (v_i_y / |v_i|)

Which translates to

    v_i_x = v_x - W * r_i_y
    v_i_y = v_y + W * r_i_x


- Do forward and inverse kinematics
    + Forward kinematics: (joint -> physical) Determine body movement from drive module state
    + Inverse kinematics: (physical -> joint) Determine drive module state from body movement.
    + Forward kinematics for swerve is calculated with an over determined system
    + Should really determine the error in the forward kinematics calcs

- Notes
    + 3 wheels is 'ideal' for any kind of surface because 3 points define a plane
    + Not necessarily ideal for stability
    + More wheels means we need suspension if the surface we move on isn't flat
    + controllers generally don't deal with dynamic situations



- Assumptions
    + The robot is moving on a flat, horizontal surface
    + The robot has no suspension
    + Wheel steering axis goes through the center of the wheel in a vertical direction
    + There is no wheel slip
    + There is no wheel lift-off
    + The motors are infinitely powerful and fast, i.e. there are no limits on the motor performance,
      so we can ignore them
    + All movements take the same amount of time (1 unit of time)


Once this is all done we want to do some more complicated simulations for robot behaviour that
is specific to swerve drive systems

- Simulation runs
    + Drive in circle
    + Straigh linear movement into rotation
    + linear move with rotation around center
