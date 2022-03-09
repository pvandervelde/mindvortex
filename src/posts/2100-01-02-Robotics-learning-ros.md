Title: Starting robotics - Learning Robot Operating System (ROS)
Tags:

- Robotics
- ROS
- ROS Noetic

---

- ROS is a framework / OS for robots. Used in many places
- Great because it provides many integrations and base functions
- Learning curve is very steep
- Decided to do a Udemy course
  - INSERT COURSES HERE
- The first and second course were very useful
- Not going to explain how ROS works. There are many pages that do so already


Catches I found

- Running ROS on Windows can be done, either via Robostack straight on windows, or using WSL2.
- If you use WSL2 then keep in mind that you can run virtual robots via Gazebo and RViz, but
  connecting to physical robots is difficult due to the fact that the WSL2 system doesn't really
  allow uninitiated network connections, i.e. request-response initiated from inside WSL2 works, but
  a request that comes from outside WSL2 going into WSL2 will not work. This is important because
  ROS nodes need to talk to each other.
- Ubuntu VMs work well, also physical machines work well, but then you need to have one
- Foxglove studio is useful

- Debugging: Setting debug level logs

- Turtlebot3 is a good example of how to set things up, but remember that it was created a while
  ago and ROS is evolving.

- The navigation stack is big and requires lots of learning. More posts about that will undoubtedly
  be posted later.
- The ROS 1 navigation stack assumes you have a Lidar or similar way of getting object distances
