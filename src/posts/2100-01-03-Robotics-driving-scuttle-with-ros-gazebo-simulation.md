Title: Starting robotics - Driving scuttle with ROS - Gazebo simulation
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

After getting familiar with [ROS](Robotics-learning-ros) the next step was to get the ROS
navigation stack working in Gazebo for the SCUTTLE robot. Fortunately the SCUTTLE developers
had already created a number of ROS packages containing the
[scuttle model](https://github.com/scuttlerobot/scuttle_description),
[the startup](https://github.com/scuttlerobot/scuttle_bringup) scripts and the
[driver code](https://github.com/scuttlerobot/scuttle_driver). All the bits you need
in order to drive SCUTTLE around using ROS.

The first step is to drive the SCUTTLE model around in [Gazebo](https://gazebosim.org/)
and drive it around using the [keyboard](http://wiki.ros.org/teleop_twist_keyboard).
For this I ran Gazebo and RViz using WSL2, which worked well but was a bit slow.

The next challenge was to make the virtual SCUTTLE drive to a specific point using a custom
ROS node. While doing the [ROS for beginners I](https://www.udemy.com/course/ros-essentials/) course
I wrote some code to do a move-to-goal for the [turtlesim](http://wiki.ros.org/turtlesim) virtual
robot. So that [code](https://gist.github.com/pvandervelde/35200cce52d416d899c3db600c98a4a5) was updated
and then reused for the SCUTTLE robot. The result is a robot that
[moves to a goal](https://www.youtube.com/watch?v=TI9tfzn8yXE&list=PLSB3dkFkgyWWY6Wr-5Q7BxVi8YF2wk_C_&index=2&ab_channel=PatrickvanderVelde),
mission accomplished!

The final challenge, for now at least, is to get the navigation stack to work for SCUTTLE. In order
to do so a few new packages needed to be created. The packages I created are

- [scuttle_slam](https://github.com/scuttlerobot/scuttle_slam) - Contains the configurations and
  launch files for running [gmapping](http://wiki.ros.org/gmapping) SLAM using the SCUTTLE LIDAR.
- [scuttle_navigation](https://github.com/scuttlerobot/scuttle_navigation) - Contains the
  configuration for working with the [navigation stack](http://wiki.ros.org/navigation).
- [scuttle_gazebo](https://github.com/scuttlerobot/scuttle_gazebo) - Contains a number of Gazebo
  worlds for testing our virtual SCUTTLE.

The `scuttle_slam` and `scuttle_navigation` packages are based on the similar packages for
[turtlebot3](https://github.com/ROBOTIS-GIT/turtlebot3) with adjustments so that the configuration
matches SCUTTLE's performance.


!!! PICTURE OF SCUTTLE WITH PATH !!!!



For navigation in ROS1 you need two different types of path planners and a map for each planner. The
first one is the global planner, which uses a map to determine the fastest path from the current
location to the goal location. The second planner, called the local planner, navigates the robot to
the goal by trying to follow the path created by the global planner. The path followed by the local
planner may deviate from the global path due to previously unknown obstacles and limitations of the
robot, e.g. the ability to follow a turn. The map for each planner is known as a [costmap](http://wiki.ros.org/costmap_2d)
which indicates which part of the surroundings are occupied by obstacles and which parts can be
navigated. After configuring the planners and the costmaps the navigation worked and I could use
RViz to set a point on the map and the virtual SCUTTLE would navigate to that location automatically.
Success!

Now not everything was fine. The [first issue](https://answers.ros.org/question/397737/dwa-local-planner-cant-find-a-trajectory-unless-rotate-recovery-runs)
is some weird behaviour with the [DWA local planner](http://wiki.ros.org/dwa_local_planner?distro=noetic).
Once the robot is moving the local planner mostly does a good job, however when starting a path it
takes a while for the local planner to pick up the global path, in fact the DWA planner doesn't seem
to [accept the global plan](https://www.youtube.com/watch?v=Nt9XyJHzfas&ab_channel=PatrickvanderVelde)
until after a [rotate recovery](http://wiki.ros.org/rotate_recovery?distro=noetic) has taken place.
At the time of writing I hadn't found a solution to this problem.

The second issue is that in some cases the navigation stack fails to find a path out of a narrow
hallway or though a narrow door. In general this happens when exploring a location, e.g. using the
[explore_lite](http://wiki.ros.org/explore_lite) package. It seems that in general the algorithm
can't find a turn that will turn the robot around, even though scuttle is able to perform in-place
rotations. At the start of a navigation exercise in-place rotations are gladly used, but once the
robot is on the move the algorithm doesn't seem to apply those anymore. Further investigation into
the correct configuration is necessary.

Finally you have to keep in mind that the default planners for ROS are path planners. This means that
they plan a path from the start to the destination. These paths however only describe the direction
a robot should take at a given location, they don't describe the velocity or acceleration. Only
describing the direction can lead to paths that contain abrupt turns, forcing the robot to slow
down significantly. Using a trajectory planner, which prescribes at least velocities, makes for a
smoother experience for the robot and its cargo. This might be important if the robot
is carrying delicate cargo. Additionally path planning for flying robots requires planners that take
into account velocities and accelerations.
