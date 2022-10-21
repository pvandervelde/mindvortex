Title: Starting robotics - Making URDF models
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

- Scuttle in simulation has issues where it slowly drifts across the map
    + One reason given on the interwebz is that the contact calculation is wrong
    + Inertias of the different parts are important
    + friction is important


Different ways we can make a model of our robot for use with ROS and Gazebo

* Start simple with primitives

* Make sure to get the collision geometry right. It's probably more sensible to use primitives
  for the collision geometry
* Inertia needs to be reasonably accurate
* Can use meshes for the visual geometry

* Moving parts should be their own link

* Always have a foot print frame with nothing in it
  * You don't get to define the location of the top level frame (during use it gets anchored by the odom / map)

