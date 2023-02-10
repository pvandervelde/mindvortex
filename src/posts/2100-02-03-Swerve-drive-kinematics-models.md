Title: Swerve drive - Kinematics models
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

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
    + Inverse kinematics is
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
