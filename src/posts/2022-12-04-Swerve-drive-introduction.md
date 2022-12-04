Title: Swerve drive - Moving a robot in all directions, mostly
Tags:

- Robotics
- Swerve
- Omnidirectional

---

Over the last year I have been using my [SCUTTLE robot](https://www.scuttlerobot.org/) as a way of
learning about robotics and all the related fields like mechanics and electronics. A major part of
this journey is the desire to design and build an autonomous mobile robot from the ground up.

My goal is to build an off-road capable robot that can navigate autonomously between different
locations to execute tasks either by itself or in cooperation with other robots. This is
quite an inspirational goal that involves quite a few robot different parts, a lot
of code and many hours of building and testing to achieve.

The chassis of the robot will have four drive modules. Each module has one wheel attached that will
both be independently driven, and independently steerable. This configuration is called
`four wheel independent steering` or `swerve drive`. These kind of steering systems are used in
[heavy transport](https://en.wikipedia.org/wiki/Self-propelled_modular_transporter),
agriculture machines, [mars rovers](https://en.wikipedia.org/wiki/Curiosity_(rover)) and
[robot competitions](https://www.chiefdelphi.com/t/best-frc-swerve-drive/399865). The advantages of
a swerve drive system are that:

- It provides a high degree of mobility. In a swerve drive direction of movement and orientation
  are independent so the robot can face forwards while driving sideways. Additionally in a swerve drive
  the [Instantaneous Center of Rotation (ICR)](https://en.wikipedia.org/wiki/Instant_centre_of_rotation#:~:text=The%20instant%20center%20of%20rotation,a%20particular%20instant%20of%20time.)
  is not fixed to a specific line as it is with [Ackermann steering](https://en.wikipedia.org/wiki/Ackermann_steering_geometry)
  or [differential drive](https://en.wikipedia.org/wiki/Differential_wheeled_robot). This flexibility
  allows the swerve drive to combine rotational movements with linear movements in ways that
  other drive systems cannot.
- It has normal size wheels which provide a high carry capacity. While
  [omni-wheels](https://en.wikipedia.org/wiki/Omni_wheel) have the similar degree of freedom as a
  swerve drive does, omni-wheels but can often not carry the same load due to the lower carrying
  capacity of the rollers.
- It doesn't rely on wheel slip, as multi-wheel differential drive does. This means that it has
  lower power demands, so more of the motor torque can be used to move the robot forward.
- It has the ability to traverse rough and dirty terrain due to the fact that all wheels are
  driven as well as using normal wheels on each drive module. Omni-wheels and [mecanum wheels](https://en.wikipedia.org/wiki/Mecanum_wheel)
  face more issues in these environments due to dust and dirt clogging up the wheels as well as
  having greater difficulty tackling obstacles.
- It is able to keep ground disturbance to a minimum as it is able to steer the robot while minimizing
  sliding movement. Other drive systems, e.g. tracks or multi-axle differential drives, have a bigger
  impact due to the sliding movement required for these systems to turn the robot.

Of course the swerve drive system isn't a magical system that only has advantages. There are also plenty
of disadvantages. For instance swerve drive systems:

- Are mechanically complicated. They require multiple motors per unit and multiple units per robot.
  On top of that there are usually a number of mechanical components, gears and bearings, involved
  in getting a working swerve drive.
- Need a complicated control system. Swerve systems are generally
  over-determined, i.e. they have more degrees of freedom in the drive system, 2 per drive module,
  than there are degrees of freedom in the robot, 2 translation directions and a rotation. This
  means that all modules have to be synchronised at all times in order to prevent wheels from being
  dragged along. The available degrees of freedom combined with the synchronisation demand means some
  complicated math is required to make a swerve drive control work.
- Similar to the control side of the drive determining the position and velocity of the robot using
  wheel [odometry](https://en.wikipedia.org/wiki/Odometry) requires more complicated math. This is
  due to the fact that the different drive modules don't necessarily agree with each other.
- Have more failure modes than other drive systems due to the fact that there are more moving parts.

So with all these complications why would I try to build a swerve drive as my second robot and not
a differential drive robot or something similar. As pointed out previously there are good
reasons to use a swerve drive in an outdoor environment, i.e. high agility, good load capacity,
traction from all wheels, low ground impact. However the main reason I want to design and build a
swerve drive is because it is a challenge. Swerve drives are complicated and designing and building
one involves solving interesting problems in mechanical engineering, electrical engineering and
software engineering.

There is currently no complete design for this robot yet, however there is a short list of design
decisions that have been made so far.

- It will be a four wheel swerve drive robot. Swerve drives have been built with anything from
  three wheels up, e.g. the Curiosity mars rover has 6 drive modules. The reason to use four modules
  is that it will be symmetrical and still minimize the number of parts necessary.
- The software for the robot will be using [ROS2 Humble](https://docs.ros.org/en/humble/index.html).
  Using ROS should provide me with a base framework and a lot of standard capabilities, like the
  navigation stack, that I won't have to write myself. Additionally ROS has a decent simulation
  environment that will allow me to test my code before putting it on a real robot.
- The hardware will be controlled using [ROS2 controllers](https://control.ros.org/master/index.html).
  This will allow me to abstract the hardware so that I can better test the controller.
- The initial design will be an indoor model and about the same size as my SCUTTLE robot is. This will
  simplify the initial design and allow me to compare with SCUTTLE.

The parts of the robot that I expect to be complicated and quite possibly show stoppers are the
software and the mechanical design. For the software the drive controller software, which translates
the requested velocity commands to motor commands for both the drive and steering motors, will be
complicated as it needs to make sure that all drive modules are the correct state. This piece of
software also needs to handle all the error conditions that occur.

On the mechanical side I need to design the drive module such that it can drive the wheel forwards
and backwards while allowing 'infinite' steering rotation. This will require a co-axial setup and a
bit of gearing. The second complicated part of the mechanical design is the inclusion of a suspension
system. Ideally the motors should be attached to the sprung side of the suspension system so that
they don't get exposed to excessive vibration. This however will complicate the mechanical design.

<iframe
    style="float:left"
    width="560"
    height="315"
    src="https://www.youtube.com/embed/fR47Y7p4mtQ"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
</iframe>

My plan is to work on the control software first. I can test that software using simulation and so
figure out if I can even make it work. I have created a simple URDF model that uses
ROS2 controllers to simulate a four wheel steering platform. This allowed me to learn more about
ROS2, ROS2 controls and how the interaction of those two with Gazebo works.

At the moment I'm implementing a prototype for the controller in python so that I can use the model to
test if my algorithm works before I turn it into a proper ROS2 controller, which will need to be
written in C++.

Once I have some kind of controlling software I am aiming to build a single drive module with a drive
motor, a steering motor and the mechanical assembly that allows a single wheel to be steered and driven.
I will use this module to work out both the details on the mechanical and software sides of the project.

Once I have the controller and the drive module working properly I will build a simple robot, similar
in size to my SCUTTLE robot to further work on swerve drives. It will take me a little while
to get to that state though. In the mean time I will keep working on my design and documenting my
journey.
