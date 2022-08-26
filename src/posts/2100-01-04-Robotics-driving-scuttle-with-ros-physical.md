Title: Starting robotics - Driving scuttle with ROS - Physical
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

- Learning to drive Scuttle with ROS
- Used teleop keyboard
- Used the teleop joystick
- scuttle_ros_service - systemd daemon to run ROS when SCUTTLE starts

Lessons learned

- Start ROS when the robot starts --> Using systemD

- Picture of SCUTTLE in gazebo / rviz / foxglove

- Maybe link to a video of driving scuttle in Gazebo / rviz and one of scuttle driving for real

- Need to check the odometry

Things to do

- Push the logs off the robot and not store them on the Rpi
- Stream metrics off the robot and setup Grafana
- Get some better sensors, currently I don't have a LIDAR or any sensors really
  - First sensor we'll be getting is a bumper sensor, more on that
