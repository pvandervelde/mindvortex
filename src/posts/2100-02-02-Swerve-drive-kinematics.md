Title: Swerve drive - Kinematics and dynamics
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

- Because a swerve drive has many degrees of freedom (2 per wheel) you need to make sure that
  all the wheel velocities and angles agree with each other, otherwise the wheels slip
    + Note that even when you do so, there's still the option of controlling the orientation
      of the robot independently of the movement of the robot.

- For swerve control often people calculate the next desired state and then set the
  wheel position and velocity to those required for that desired state.
    + This doesn't feel right because there is travel time between the current module
      state and the next one.
    + While changing the state the intermediate states of each modules should match
      the other modules so that all the wheels point in the right direction at all
      times.
- often people limit the steering movement in favour of reversing the wheel direction,
  however this isn't necessarily the right approach
    + Wheels have inertia, stopping a wheel takes energy. Note that wheels are also
      gyroscopes so turning it also takes energy
    + Motors have a maximum and minimum speed
    + Also depends on the surroundings, in some cases you can take a wider turn, thus
      you don't need to stop the entire vehicle and accelerate it again. In other
      cases there is not enough space for a wider turn.
    + Finally the wheel movement isn't independent from the movement of the other
      wheels / the robot.
- For driving on horizontal flat surfaces (with no wheel slip or wheel lift off) we
  have to take the ICR (Instantaneous Centre of Rotation) into account. This is the
  point in space around with the robot turns. All wheels have to be pointing to this
  ICR and be moving with the correct velocity. At all times, including during transition
  from one movement to another.
    + In case of a 3D (i.e. uneven) surface and / or a robot with suspension, the ICR
      is more difficult to define. And generally the ICR is not used in these cases.

- One part of the algorithm is to determine what the steering angles and velocities of
  each wheel. The other part of the algorithm is the trajectory for getting from the
  current state to the desired state.



- I feel that I don't understand how a swerve drive works well enough. There are many
  variables that influence the behaviour. So I wrote some code to simulate what is
  going on (roughly) in a swerve drive while it is moving and steering.

