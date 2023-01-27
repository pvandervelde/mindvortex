Title: Swerve drive - Kinematics and dynamics
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

As [mentioned](posts/Swerve-drive-introduction) I am designing and building four wheel steering
mobile robot. My first task is to see if I can create some software that would allow me to control
the robot. A four wheel swerve drive has eight degrees of freedom for three spatial degrees of
freedom (forward, sideways and rotate). This makes a swerve drive an over-determined system, so the
control system has to make sure that all the wheel velocities and angles agree with each other,
otherwise the wheels slip.

While doing some research I found many
[different](https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=multi+wheel+steering&btnG=)
[scientific](https://scholar.google.com/scholar?hl=en&as_sdt=0,5&q=multi+wheel+steering+icr+mobile+robots)
[papers](https://scholar.google.com/citations?hl=en&user=H10kxZgAAAAJ&view_op=list_works&sortby=pubdate)
but very [few]() [software]() [libraries]().

Most papers focus on indoor robots that move along flat horizontal surfaces although there are
some papers that deal with more complicated algorithms for
[3d uneven terrain](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=H10kxZgAAAAJ&sortby=pubdate&citation_for_view=H10kxZgAAAAJ:Se3iqnhoufwC).

Reading through the
available code it seems that most developers implement a
[simple kinematics approach](https://www.chiefdelphi.com/t/paper-4-wheel-independent-drive-independent-steering-swerve/107383).

- Simple kinematics implemented, with simple odometry
- Generally assumes static states for the control, i.e. control commands point to the next
  state, but don't take any transition between states into account


Even after reading a number of papers and looking at some of the available code I have come to the
conclusion that I don't understand what is required for a successful swerve algorithm. There are
many variables that influence the behaviour. So I wrote some code to simulate what is going on
(roughly) in a swerve drive while it is moving and steering.





- For swerve control often people calculate the next desired state and then set the
  wheel position and velocity to those required for that desired state.
    + This probably assumes a linear behaviour between the start and end point, however
      in reality the behaviour depends on the motor curves
    + This doesn't feel right because there is travel time between the current module
      state and the next one.
    + While changing the state the intermediate states of each modules should match
      the other modules so that all the wheels point in the right direction at all
      times.
- often people limit the steering movement in favour of reversing the wheel direction. This is probably
  done to complete the steering movement faster, i.e. a maximum rotation of -90 to 90 from the
  current position. However this doesn't take into account the interaction between the modules
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
    + Different algorithms for this.





