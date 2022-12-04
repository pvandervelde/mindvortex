Title: Swerve drive - Kinematics and dynamics
Tags:

- Robotics
- Swerve
- Omnidirectional

---

- Because a swerve drive has many degrees of freedom (2 per wheel) you need to make sure that
  all the wheel velocities and angles agree with each other, otherwise the wheels slip
- One part of the algorithm is to determine what the steering angles and velocities of
  each wheel. The other part of the algorithm is the trajectory for getting from the
  current state to the desired state.
    + While changing the state the intermediate states of each modules should match
      the other modules so that all the wheels point in the right direction at all
      times.
- often people limit the steering movement in favour of reversing the wheel direction,
  however this isn't necessarily the right approach
    + Wheels have inertia, stopping a wheel takes energy. Note that wheels are also
      gyroscopes so turning it also takes energy
    + Also depends on the surroundings, in some cases you can take a wider turn, thus
      you don't need to stop the entire vehicle and accelerate it again. In other
      cases there is not enough space for a wider turn.
    + Finally the wheel movement isn't independent from the movement of the other
      wheels / the robot.


- Have to deal with 3D systems
- Wheel slip
- Lift off

Neal Seegmiller   -  <https://scholar.google.com/citations?hl=en&user=H10kxZgAAAAJ>


High-fidelity yet fast dynamic models of wheeled mobile robots
N Seegmiller, A Kelly - IEEE Transactions on robotics, 2016


Recursive kinematic propagation for wheeled mobile robots
A Kelly, N Seegmiller - The International Journal of Robotics Research, 2015


Dynamic model formulation and calibration for wheeled mobile robots
NA Seegmiller - 2014

Energy-aware Planning and Control of Off-road Wheeled Mobile Robots
ND Wallace - 2020
