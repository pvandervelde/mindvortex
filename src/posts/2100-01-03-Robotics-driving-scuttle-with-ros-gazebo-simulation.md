Title: Starting robotics - Driving scuttle with ROS - Gazebo simulation
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

- Learning to drive Scuttle with ROS
- First doing this virtually via Gazebo and RViz so that we leave out the physical hardware issues
- Lots of bits for Scuttle ROS already done
- Used teleop keyboard

- Packages for ROS with SCUTTLE
  - scuttle_description
  - scuttle_bringup
  - scuttle_slam
  - scuttle_navigation
  - scuttle_gazebo

- I added the scuttle_gazebo, scuttle_slam and scuttle_navigation packages. Based on the turtlebot3
  settings but adjusted for SCUTTLE

- Navigation
    + Navigation in ROS1 consists requires a global planner, takes the map and determines a path
    from the current location to the goal, and local planner, which moves the robot towards the
    goal and tries to follow the path planned by the global planner
    + Default ROS nav is path planning, a route from A to B, but it doesn't prescribe velocities /
  acceleration along the path. For that you need trajectory planner. Drone path planning is
  often done in trajectory planning, prescribing both velocity and accelerations along the path to
  ensure the most smooth path



Lessons learned

- Configuration that describes the robot. There are many parts and some information is duplicated
  - Gazebo has information about the drive system, so does the navigation stack

- Picture of SCUTTLE in gazebo / rviz / foxglove

- Maybe link to a video of driving scuttle in Gazebo / rviz
- DWA weirdness still to be investigated