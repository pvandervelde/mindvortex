Title: Swerve drive - Implementation
Tags:

- Robotics
- Swerve
- Omnidirectional

---

- After doing the simulations of the robot driving around it is now time to move to another level of simulation. Using
  ROS2 and Gazebo we can simulate an actual robot driving around
- For this to work we need the model of a robot (zinger_description). In my case a simple rectangular box with wheels attached
- And we need some way to control the joints, i.e. the steering of each wheel and the rotation of each wheel
  - Define what a joint and a link is
- The ros2_control library provides an abstraction over the control of robot joints

- Simulation in Gazebo, using a python node
  - No motor limits
  - Using the code from the swerve sim
- Finally a ROS controller, written in Rust