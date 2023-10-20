Title: Starting robotics - Making URDF models
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

- When you want to simulate a robot there are different ways. One of those ways is to use ROS and Gazebo
- Define links and joints

Different ways we can make a model of our robot for use with ROS and Gazebo

* Start simple with primitives

* Make sure to get the collision geometry right. It's probably more sensible to use primitives
  for the collision geometry
* Inertia needs to be reasonably accurate
* Can use meshes for the visual geometry

* Moving parts should be their own link

* Always have a foot print frame with nothing in it
  * You don't get to define the location of the top level frame (during use it gets anchored by the odom / map)


- Can use meshes on the visual geometry to make the robot look good
  - But generally we keep the collision and inertia geometry simple

- Other parts of the geometry include ROS control nodes etc.

- Materials and colours