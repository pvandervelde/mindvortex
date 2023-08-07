Title: Starting robotics - Uncommanded drifting in Gazebo
Tags:

- Gazebo
- Robotics
- Scuttle
- ROS
- ROS Noetic

---

- SCUTTLE drifts in Gazebo when no Twist commands are given
    + This seems to be caused by incorrect moments of inertia as well as issues with the collision geomtry
    + Also possible not enough friction

- Graphs of movement

- Figure out if movement is only in forward direction
    + Is any rotation caused by the differential movement of the wheels
    + are the wheels actually rolling

- New URDF geometry to improve the collision geometry

- Add friction to the forward movement

