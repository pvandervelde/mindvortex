Title: Swerve drive - Kinematics and dynamics simulations
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

- Simulation in python code first. To get some idea of what's going on and to avoid having to spin up ROS
- Implemented several algorithms
    + Base module desired state on desired body end state. Assume linear profiles
    + Modules turn shortest direction
    + Create body trajectory, derive module trajectories. Assume body trajectory is linear
    + Create body trajectory, derive module trajectories. Use low jerk algorithms

- All these algorithms make the following assumptions
    + The robot is moving on a flat, horizontal surface
    + The robot has no suspension
    + There is no wheel slip
    + There is no wheel lift-off

- As I'm interested in outdoor mobile robots eventually I'll have to deal with uneven surfaces,
  wheel slip and wheel lift-off. And robots that move around in a 3D world and have
  suspension.
    + For these cases you need a more advanced algorithm than the one I have used.
      Neal Seegmiller has developed one such algorithm that will be implemented
      in a later stage.


Neal Seegmiller   -  <https://scholar.google.com/citations?hl=en&user=H10kxZgAAAAJ>

High-fidelity yet fast dynamic models of wheeled mobile robots
N Seegmiller, A Kelly - IEEE Transactions on robotics, 2016

Recursive kinematic propagation for wheeled mobile robots
A Kelly, N Seegmiller - The International Journal of Robotics Research, 2015

Dynamic model formulation and calibration for wheeled mobile robots
NA Seegmiller - 2014

Energy-aware Planning and Control of Off-road Wheeled Mobile Robots
ND Wallace - 2020
