Title: Swerve drive - Kinematics and dynamics simulations
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

- Simulation in python code first. To get some idea of what's going on and to avoid having to spin up ROS
- Implemented several algorithms
    + Base module desired state on desired body end state. Assume linear profiles. These are generally
      a reflection of the behaviour I have seen in other algorithms, making the wheel velocity and
      steering angle change from one value to another (with no control over the intermediate states)
    + Modules turn shortest direction
    + Create body trajectory, derive module trajectories. Assume body trajectory is linear
    + Create body trajectory, derive module trajectories. Use low jerk algorithms
- All control algorithms based on simple kinematics
    + insert pics and math here

- All these algorithms make the following assumptions
    + The robot is moving on a flat, horizontal surface
    + The robot has no suspension
    + There is no wheel slip
    + There is no wheel lift-off
    + The motors are infinitely powerful and fast, i.e. there are no limits on the motor performance,
      so we can ignore them
    + All movements take the same amount of time (1 unit of time)

- What are the goals for these simulations
    + To help me understand what is happening with the robot body given certain drive module behaviour
      and visa versa
    + To see what happens with the ICR and other bits for given control profiles. So that we can find out
      which kind of control you need for smooth movement in a 4 wheel steering system
    + To learn what kind of control requests are necessary for certain movements

- What kind of movement profiles are we running
    + Some simple ones for verification of the simulation
        * straight forward from stand still
        * straight sideways from stand still with modules pointing in the right direction
        * straight sideways, rotating modules in right direction before movement
        * 45 degree forward movement, modules in the right direction before movement


In a later stage we may want to create a reverse simulation, where we specify a path for the robot
to follow and then translate that into movement commands


