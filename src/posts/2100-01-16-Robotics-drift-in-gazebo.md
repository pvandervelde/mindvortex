Title: Starting robotics - Uncommanded drifting in Gazebo
Tags:

- Gazebo
- Robotics
- Scuttle
- ROS
- ROS Noetic

---

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

