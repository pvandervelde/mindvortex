Title: Starting robotics - Making URDF models
Tags:

- Robotics
- ROS
- ROS2
- Gazebo
- Simulation

---

In a [previous post](posts/Robotics-driving-scuttle-with-ros-gazebo-simulation) I talked about simulating
the [SCUTTLE robot](https://scuttlerobot.org) using ROS and Gazebo.  The reason I used Gazebo to
simulate the SCUTTLE robot was so that I could learn more about ROS without needing to involve a real
robot with all the setup and complications that come with that. Additionally when I was designing the
[bump sensor](posts/Robotics-a-bumper-for-scuttle-overview) for SCUTTLE using the simulation allowed
me to reduce the feedback time compared to testing the design on a physical robot. This speeds up
the design iteration process and allowed me to quickly and verify the design and the code. In the end
you always need to do the final testing on a real robot, but by using simulation you can quickly
iterate to a solution without major issues.

In order to progress my [swerve drive robot](posts/Swerve-drive-introduction) I wanted to verify that
the control algorithms that I had developed would work for an actual robot. Ideally before spending
money on the hardware. So I decided to use Gazebo to run some simulations that would enable me to
verify the control algorithm.

In order for me to use Gazebo as my simulation environment I had to create a model of the robot
and its surrounding environment. As there are some interesting details to this process I will
describe it in this post.

Gazebo natively uses the [SDF](http://sdformat.org/) format to define both the robot and the
environment. However if you want ROS nodes to be able to understand the geometry definition of your
robot you need to use the [URDF](http://wiki.ros.org/urdf) format. This is important for instance
if you want to make use of the [tf2](https://docs.ros.org/en/humble/Concepts/Intermediate/About-Tf2.html)
library to transform between different coordinate frames then your ROS nodes will have to have the
[geometry of the robot](https://github.com/ros/robot_state_publisher/tree/humble) available.

There are different ways to create an URDF model. One way is to draw the robot in a CAD program
and then use a plugin to export the model to an URDF file. This is a relatively quick approach, it
takes time to create the robot in the CAD program but then the export is very quick. The drawback
of this method is that the resulting URDF file is not very clean which makes it harder to edit
later on.
Another way is to create the URDF manually. This approach is slower than the CAD export approach,
however it results in a much more minimal and clean URDF file. This makes editing the file at a
later stage a lot easier. Additionally manually creating the URDF file give you a better understanding
of the URDF format and how it works. In the end the model for my swerve drive robot is very simple,
consisting of a body, four wheels, the steering and drive controllers and the sensors. So I decided
to create the URDF file manually.

IMAGE OF ZINGER URDF MODEL

The URDF model describes the different parts of the robot relative to each other. The robot parts
consist of the physical parts of the robot, the sensors and the actuators. The physical parts, e.g.
the wheels or the body, are described using [links](https://wiki.ros.org/urdf/XML/link). The links
are connected to each other using [joints](https://wiki.ros.org/urdf/XML/joint). Joints allow the
links to move relative to each other. Joints can be fixed, e.g. when two structural parts are statically
connected to each other, or they can be movable. If a joint is movable then be one of:

- A revolute joint, which allows the two links to rotate relative to each other around a single axis.
- A continuous joint, which is similar to a revolute joint but allows the joint to rotate continuously
  without any limits.
- A prismatic joint, which allows the two links to move relative to each other along a single axis.
- A floating joint, which allows the two links to move relative to each other in 6 degrees of freedom.
- A planar joint, which allows the two links to move relative to each other in 3 degrees of freedom
  in a plane.

In the URDF file each link defines the visual geometry, the collision geometry and the inertial
properties for that link. The visual and collision geometry can be defined either by a primitive
(box, cylinder or sphere) or a triangle mesh. It is recommended to use simple primitives for the
collision geometry since these make the collision calculations faster and more stable. If you use a
triangle mesh for the collision geometry then you can get issues with the collision detection. This
can lead to the robot moving around when it shouldn't. For instance when the wheel of the robot is
modelled as a triangle mesh then the collision calculation between the wheel and the ground may not
be numerically stable which leads to undesired movement of the robot. The current version of the SCUTTLE
URDF has this problem. In a future post I'll describe how to fix this.

Using meshes for the visual geometry is fine as this geometry is only used for the visual
representation of the robot. Note that the meshes should be relatively simple as well since Gazebo
will have to render the meshes in real time which is expensive if the mesh consists of a large number
of vertices and triangles.

I normally start by defining a link that represents the [footprint](https://www.ros.org/reps/rep-0120.html#base-footprint)
of the robot on the ground, called `base_footprint`. This link doesn't define any geometry, it is
only used to define the origin of the robot. When navigation is configured it will be referencing
this footprint link. The next link that is defined is the `base_link`. This link is generally defined
to be the 'middle' of the robot frame and it forms the parent for all the other robot parts.

The next step is to define the rest of the links and joints. For the swerve drive robot I have four
drive modules, each consisting of a wheel and a steering motor. The wheel is connected to the steering
motor using a continuous joint. The steering motor is connected to the base link using another continuous
joint. Because the four modules are all the same I use the [xacro](http://wiki.ros.org/xacro) format.
This allows me to define [a single module as a template](https://github.com/pvandervelde/zinger_description/blob/bb24b884f8bcc62c9c2e8f12bac431f4b62dea6f/urdf/macros.xacro)
and then use that template to create the four modules. The benefit of this is that it makes the URDF
file easier to edit and a lot smaller and easier to read.

To add sensors you need to add two pieces of information, the information about the sensor body and,
if you are using gazebo, the information about the sensors behaviour. The former consist of the
visual and collision geometry of the sensor. The latter consists of the sensor plugin that is used
to simulate the sensor. For the swerve drive robot I have two sensors, a lidar and an IMU.

- The Lidar is there so that I can run SLAM algorithms easily.
- The IMU is there to learn more about IMU's

- Additional other bits
    + ROS2 control
        - `ign_ros2_control/IgnitionSystem`
        - <https://github.com/pvandervelde/zinger_description/blob/bb24b884f8bcc62c9c2e8f12bac431f4b62dea6f/urdf/gazebo.xacro#L148>
        - <https://github.com/pvandervelde/zinger_description/blob/bb24b884f8bcc62c9c2e8f12bac431f4b62dea6f/urdf/base.xacro#L205>
    + Gazebo specific information
        - A gazebo reference for each wheel to specify the friction coefficients etc.
        - Lidar - based on the rplidar
    + Materials and colours

- Issues you can come across

- Once you have the URDF you need to get Gazebo to load it.
    + Load the `robot state publisher` and provide it with the robot description (URDF)
    + Spawn the robot in Gazebo using the `ros_ign_gazebo` package with the command line

``` python

    def generate_launch_description():
        spawn_robot = Node(
            package='ros_ign_gazebo',
            executable='create',
            arguments=[
                '-name', LaunchConfiguration('robot_name'),
                '-x', x,
                '-y', y,
                '-z', z,
                '-Y', yaw,
                '-topic', '/robot_description'], # <-- There might not be a topic with this ....
            output='screen')

        # Define LaunchDescription variable
        ld = LaunchDescription(ARGUMENTS)

        # .... Load all your other Nodes here ....

        # Spawn the model in Gazebo.
        ld.add_action(spawn_robot)

        return ld
```

- If you set up the ros2 controls then you can directly control the different joints of the robot
  with the appropriate commands.
