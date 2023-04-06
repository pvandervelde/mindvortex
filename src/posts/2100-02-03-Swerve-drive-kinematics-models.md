Title: Swerve drive - Kinematics models
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

As I explained in an [earlier post](posts/Swerve-drive-kinematics-simulation) I have written some
code to simulate the movement of a four wheel swerve drive. Currently I have only implemented a
[simple kinematics based approach](https://www.chiefdelphi.com/t/paper-4-wheel-independent-drive-independent-steering-swerve/107383).
This approach is based on the following degrees of freedom for the swerve drive as well as
the coordinate systems for the different parts.

<figure style="float:left">
  <a href="/assets/images/robotics/swerve/swerve-dof.png" target="_blank">
    <img alt="Swerve drive degrees of freedom" src="/assets/images/robotics/swerve/swerve-dof.png" />
  </a>
  <figcaption>Degrees of freedom for a swerve drive system.</figcaption>
</figure>

The simple kinematics approach makes a number of assumptions which greatly simplify the problem
space.

- The steering axis of a drive module is vertical and passes through the centre of the wheel, i.e.
  no positional changes occur when the wheel steering angle changes.
- The robot is moving on a flat, horizontal surface, i.e. the contact point between the wheel and
  the ground is always inline with the steering axis of a drive module.
- The robot has no suspension, i.e. the body doesn't move vertically relative to the contact
  point between the wheel and the ground.
- There is no wheel slip.
- There is no wheel lift-off, i.e. the wheels of the robot are always in contact with the ground.
- The motors are infinitely powerful and fast, i.e. there are no limits on the motor performance.

With diagram and the given assumptions we can derive the equations for the wheel velocity
and the steering angle of each drive module.


    v_i = v + W x r_i

    alpha_i = acos (v_i_x / |v_i|)
          = asin (v_i_y / |v_i|)

Where

- `v_i` - the wheel velocity of the i-th drive module, i.e. the velocity at which the drive module
  would move forward if there is no wheel slip. The `x` and `y` components of this vector are
  named as `v_i_x` and `v_i_y`.
- `v` - the linear velocity of the robot.
- `W` - the angular velocity of the robot.
- `r_i` - the position vector of the i-th drive module.
- `alpha_i` - the steering angle of the i-th drive module relative to the robot coordinate system.

Based on these equations we can determine the forward kinematics, i.e. which translates the movement
of the drive modules to the movement of the robot body, and the inverse kinematics, i.e. which translates
the movement of the robot body to the movement of the drive modules. When doing the calculations for
a four wheel swerve drive it is important to note that the forward kinematics calculations are
[overdetermined](https://en.wikipedia.org/wiki/Overdetermined_system), i.e. there are more control
variables than there are outputs. This means that there are additional control variables that we can
play with. One obvious one for a swerve drive is that we can control the orientation of the robot body
independent[*] from the direction of movement of the robot. This also means that the forward kinematics
calculations are based on the [pseudoinverse](https://en.wikipedia.org/wiki/Moore%E2%80%93Penrose_inverse)
approach which computes a best fit, a.k.a. least squares, using the drive module wheel velocities and
steering angles.







This code gives me a graphs like in the previous post


However ....








Before I can start using this code I will
need to make sure my code is actually producing the correct results. The
[verification](https://en.wikipedia.org/wiki/Software_verification_and_validation) is  done by
running a bunch of simple simulations for which I am able to predict the behaviour using some
simple maths.


















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

- Drive the robot on the 45 degree diagonals (45 degrees, 135 degrees, 225 degrees and 315 degrees),
  i.e. equal amounts in x and y-directions, while facing in the x-direction, one simulation going
  forwards from the origin and one going backwards from the origin.
- Drive the robot on the 45 degree diagonals, while facing in the y-direction,
  one simulation going forwards from the origin and one going backwards from the origin.
- Drive the robot on the 30 degree diagonals (30 degrees, 60 degrees, 120 degrees, 150 degrees,
  210 degrees, 240 degrees, 300 degrees and 330 degrees), while facing in the x-direction, one
  simulation going forwards from the origin and one going backwards from the origin.
- Drive the robot on the 30 degree diagonals, while facing in the y-direction, one
  simulation going forwards from the origin and one going backwards from the origin.




- Forward + rotation, X + rotation
- Sideways + rotation, Y + rotation
- Diagonal + rotation


The bits of the code that need to be tested are the algorithm used to determine the drive module
behaviour. The second thing is the controller. And the third part is the trajectory code.

- We use trajectory code to move from one state (x_vel, y_vel, rot_vel) to another. The trajectory
  might be a linear one, but we specifically want trajectories so that we can alter them to something
  that is not linear

- Currently






Once this is all done we want to do some more complicated simulations for robot behaviour that
is specific to swerve drive systems

- Simulation runs
    + Drive in circle
    + Straigh linear movement into rotation
    + linear move with rotation around center




- Notes
    + More wheels means we need suspension if the surface we move on isn't flat
    + controllers generally don't deal with dynamic situations



- Do forward and inverse kinematics
    + Should really determine the error in the forward kinematics calcs



[*] Mostly independent. In reality the motors used in the drive modules will have
    limits on how fast they can be driven, how much torque they can produce and
    how fast they can change from one state to the next. This means that there
    are limitations on movements of the drive modules and thus the robot body. For
    instance if a drive module has a maximum linear velocity of 1.0 m/s it is
    not possible to drive the robot diagonally any faster than this velocity, even
    though we can drive the robot in x-direction at 1.0 m/s and we can drive the
    robot in y-direction at 1.0 m/s. We just can't do both at the same time.
