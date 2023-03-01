Title: Swerve drive - Kinematics models
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

As I explained in an [earlier post](posts/Swerve-drive-kinematics-simulation) I have written some
code to simulate the movement of a four wheel swerve drive.





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


- Validation of the model
    + Straight forward in world X-direction
    + Straight sideways in world Y-direction
    + In-place rotation around c.o.g
    + Diagonal in X, Y direction, equal parts
    + Forward + rotation, X + rotation
    + Sideways + rotation, Y + rotation
    + Diagonal + rotation

- Simulation runs
    + Drive in circle
    + Straigh linear movement into rotation
    + linear move with rotation around center
