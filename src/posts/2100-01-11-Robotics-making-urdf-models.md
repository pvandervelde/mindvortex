Title: Starting robotics - Making URDF models
Tags:

- Robotics
- ROS
- ROS2
- Gazebo
- Scuttle

---

- In a previous post I talked about simulating the SCUTTLE robot using ROS and Gazebo.

- Why simulate
    + Robotics is hard. It's hard to ensure that the product you are designing / making will do what it is intended to do.
      Especially when you are dealing with the real world. All kinds of strange things can happen.
    + In engineering one of the issues we have is that it can take a long time between our design and the final product. This
      means that we need to wait a long time before we can figure out if what we designed actually works. This can be
      very expensive, both in time and money.
        - Feedback time is important. The shorter the feedback time the better (because we can figure out quicker
          if our ideas are right or wrong). This is one reason we use simulation.
    + So we try to iterate quickly, i.e. create a design and verify it as quickly as possible. Then feed the results
      back to the design process. The faster we can iterate the better our final product becomes. Additionally we
      have prototypes we can share with our customers to ensure that it does what they want.
    + Using simulations gives us a way to shorten our feedback time. We can create a model of our robot and test it
      in a virtual environment. This allows us to test our design and verify that it does what we want it to do.
    + The other reasons for using simulation is that we can verify that things work in a safe environment. Crashing
      a robot in simulation is far less expensive than crashing a real robot. And a lot safer too.
    + Finally we can test situations that are hard to test in the real world. For example we can test the robot in
      a variety of different environments. We can test the robot in a variety of different situations. We can test
      the robot in situations that are dangerous or expensive to test in the real world.

- When you want to simulate a robot there are different ways. One of those ways is to use ROS and Gazebo
- In order to use ROS and Gazebo you need to create a model of your robot and its surroundings. The model of the
  robot is called a URDF model. The model of the surroundings is called a world model.
- The URDF model consists of the model the parts of the robots, including the mechanical parts, the sensors and the
  actuators.
- The mechanical parts of the robots consist of links and joints (link to ROS page). Links are the physical parts of
  the robot. Joints are the connections between the links. The joints allow the links to move relative to each other.

Different ways we can make a model of our robot for use with ROS and Gazebo


- There are thee different geometries that you should care about:
    + The visual geometry, what you see on the screen. Only used to make things look good
    + The collision geometry, used to calculate when two bodies collide
    + The inertial geometry, used to calculate the inertia of the body / parts

- Start simple with primitives
    + You can use meshes for all the different geometries, however this is not necessarily sensible.
      Using meshes for the collision geometry can be very expensive computationally and can also lead
      to problems with the collision detection. These problems can show themselves as issues in the simulation,
      for instance two colliding bodies start to move. This is a problem especially when one of the bodies is
      the wheel of your robot against the ground because it causes your robot to move around.
      It's better to use primitives for the collision geometry.

- Make sure to get the collision geometry right. It's probably more sensible to use primitives
  for the collision geometry. If you don't you can have issues with the model moving when it shouldn't
    + This is due to numerical issues in the collision detection. The collision detection is not perfect
      and can lead to issues when using meshes for the collision geometry. This is especially true when
      the collision geometry is very complex. For instance when using a mesh for the wheel of your robot
      and the ground. This can lead to the wheel and the ground colliding and the robot moving around
      because of this.
- Inertia needs to be reasonably accurate
- Can use meshes for the visual geometry

- Moving parts should be their own link

- Always have a foot print frame with nothing in it
    + You don't get to define the location of the top level frame (during use it gets anchored by the odom / map)


- Can use meshes on the visual geometry to make the robot look good
    + But generally we keep the collision and inertia geometry simple

- Other parts of the geometry include ROS control nodes etc.

- Materials and colours

- Issues you can come across
  -

- Scuttle in simulation has issues where it slowly drifts across the map
    + One reason given on the interwebz is that the contact calculation is wrong
    + Inertias of the different parts are important
    + friction is important

- SCUTTLE drifts in Gazebo when no Twist commands are given
    + This seems to be caused by incorrect moments of inertia as well as issues with the collision geomtry
    + Also possible not enough friction
    + Contact surface is important. Using meshes for the collision geometry might make it nasty
    + Another trick is to limit the contact surface to a line

- Graphs of movement

- Figure out if movement is only in forward direction
    + Is any rotation caused by the differential movement of the wheels
    + are the wheels actually rolling

- New URDF geometry to improve the collision geometry

- Add friction to the forward movement

