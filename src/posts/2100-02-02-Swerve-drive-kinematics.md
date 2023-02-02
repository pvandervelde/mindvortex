Title: Swerve drive - Kinematics simulation
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
otherwise the wheels slip or drag.

<figure style="float:left">
<img alt="Swerve drive degrees of freedom" src="/assets/images/robotics/swerve/swerve-dof.png" />
<figcaption>Degrees of freedom for a swerve drive system.</figcaption>
</figure>

While doing some research I found many
[different](https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=multi+wheel+steering&btnG=)
[scientific](https://scholar.google.com/scholar?hl=en&as_sdt=0,5&q=multi+wheel+steering+icr+mobile+robots)
[papers](https://scholar.google.com/citations?hl=en&user=H10kxZgAAAAJ&view_op=list_works&sortby=pubdate)
but very [few]() [software]() [libraries]() which implement the different control algorithms.

Most papers focus on the simpler case of an indoor robot that moves along a flat horizontal surface. In
this case relatively simple kinematics approaches can be used. Unfortunately these algorithms fail
when used in 3d uneven terrain. A different
[approach](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=H10kxZgAAAAJ&sortby=pubdate&citation_for_view=H10kxZgAAAAJ:Se3iqnhoufwC)
is required for that case.

Even after reading a number of papers and looking at some of the available code I have come to the
conclusion that I don't understand what is required for a successful swerve algorithm. There are
many variables that influence the behaviour. So I wrote some [code](https://github.com/pvandervelde/basic-swerve-sim)
to simulate what is going on (roughly) in a swerve drive while it is moving and steering. I'm
going to use this code to answer a number of questions I have about the different control algorithms.
For instance algorithms often calculate the desired end state and then set the wheel position and
velocity to those required for that desired state. The question is does this algorithm automatically
ensure that the intermediate states are synchronised, and if not does that matter?

Another example is that many of the code libraries add an optimization that reverses the wheel
direction in favour of reducing the steering angle. For instance instead of changing the steering
angle from 0 degrees to 225 degrees with a wheel velocity of 1.0 rad/s, change the angle to 45 degrees
and reverse the wheel velocity to -1.0 rad/s. Again there are a number of questions about
this optimization. For instance making a smaller steering angle change reduces the energy used, however
stopping and reversing the wheel motion also takes energy, so what are the benefits of this optimization,
if any? And how do the algorithms keep the wheel motions synchronised when performing the reversing
optimization?

At the moment the main parts of the simulation code are:

- [`ControlModel`](https://github.com/pvandervelde/basic-swerve-sim/blob/ffebad5d946b2840dc4a98ae11b4e4c46de08735/swerve_controller/control_model.py) -
  The control model describes the forward and inverse kinematics calculations. Currently
  the only model implemented is a [simple kinematics approach](https://www.chiefdelphi.com/t/paper-4-wheel-independent-drive-independent-steering-swerve/107383).
  This model assumes that the robot is moving on a horizontal flat surface and that it does not
  have a suspension.
- [`MultiWheelSteeringController`](https://github.com/pvandervelde/basic-swerve-sim/blob/ffebad5d946b2840dc4a98ae11b4e4c46de08735/swerve_controller/multi_wheel_steering_controller.py) -
  The controller determines the trajectory that has to be followed to move from the current state
  to the final desired state. The current controller assumes linear trajectories for the drive
  module.
- The [simulation code](https://github.com/pvandervelde/basic-swerve-sim/blob/ffebad5d946b2840dc4a98ae11b4e4c46de08735/run_trajectory_simulation.py) -
  This code wraps the controller and the control model. It sets the initial conditions, performs
  the updates of the current state and at the end of the simulation collects the results and puts
  these in a CSV file and different plots.

<figure style="float:middle">
<img alt="45 degree linear track to in-place rotation" src="/assets/images/robotics/swerve/swerve_sim_45_linear_to_inplace_rotation.png" />
<figcaption>Simulation data for a 45 degree linear track that transitions to an in-place rotation.</figcaption>
</figure>

The graphs show an example of the simulation output for the case where a robot transits from moving
at a 45 degree straight path to an in-place rotation. The graphs display the status of the robot
body, position and velocity and the status of the different drive modules, the angular orientation
and the wheel velocity. The last graph depicts the location of the Instantaneous Centre of Rotation (ICR)
for different combinations of drive modules. The ICR is the point in space around which the robot
turns. If the control algorithm is correct then the ICR points for different drive module combinations
all fall in the same location though out the entire movement pattern.

Looking at these graphs a couple of observations can be made. The first observation is that the ICR
paths for the different module combinations don't match each other. This means that the drive modules
are not synchronised and one or more wheels may be experiencing wheel slip.
The second observation is that the linear control algorithm causes sharp changes in velocities leading
to extremely high acceleration demands. It seems unlikely that the motors and the structure would
be able to cope with these demands.

- Indicates that the control algorithm needs to synchronise actively
- Indicates that linear behaviour for drive modules isn't a sensible approach. Better would be
  a higher order model, or similar

- What are the future plans?



- Plan to implement several algorithms
    + Base module desired state on desired body end state. Assume linear profiles. These are generally
      a reflection of the behaviour I have seen in other algorithms, making the wheel velocity and
      steering angle change from one value to another (with no control over the intermediate states)
    + Modules turn shortest direction
    + Create body trajectory, derive module trajectories. Assume body trajectory is linear
    + Create body trajectory, derive module trajectories. Use low jerk algorithms


- All these algorithms make the following assumptions
    + The robot is moving on a flat, horizontal surface
    + The robot has no suspension
    + There is no wheel slip
    + There is no wheel lift-off
    + The motors are infinitely powerful and fast, i.e. there are no limits on the motor performance,
      so we can ignore them
    + All movements take the same amount of time (1 unit of time)

- Verification of the model

- Future posts will provide more details about the controller and the models being used.

- All control algorithms based on simple kinematics
    + insert pics and math here
