Title: Swerve drive - Using Nav2
Tags:

- Robotics
- Swerve
- Omnidirectional
- ROS2
- Nav2

---

The [goals for the development of my swerve drive robot](posts/Swerve-drive-introduction) were to
develop an off-road capable robot that can navigate autonomously between different locations to
execute tasks either by itself or in cooperation with other robots. So far I have implemented the
first version of the [steering and drive controller](posts/Swerve-drive-body-focussed-control),
added [motion profiles](posts/Swerve-motion-profiles) for smoother changes in velocity and acceleration,
and I have created the [URDF files](posts/Robotics-making-urdf-models) that allow me to simulate the
robot in Gazebo. The next part is to add the ability to navigate the robot, autonomously,
to a goal location. This can be achieved using the [Nav2](https://navigation.ros.org/) and
[slam_toolbox](https://github.com/SteveMacenski/slam_toolbox) packages.

So how does the navigation in general work? The first step is to figure out where the robot is, or
at least what is around the robot. Using the robot sensors, e.g. a lidar, we can see what the direct
environment looks like, e.g. the robot is in a room of a building. If we have a map of the larger
environment, e.g. the building, then using a [SLAM](https://en.wikipedia.org/wiki/Simultaneous_localization_and_mapping)
algorithm we can figure out where in the building we are. Assuming there are enough features in the
room to make it obvious which room we are in. If we don't have a map of the environment then we can
use the SLAM algorithm to create a map while the robot is moving. Having a map makes planning
more reliable, because we can plan a path that takes into account the surroundings. However it is
not strictly necessary, we can also plan a path without a map, but then it is possible that the
planner will plan a path that is not possible to follow, e.g. because there is a wall in the way.
Of course if there are dynamic obstacles, e.g. if a door is closed, then the map might not be
accurate and we might still not be able to get to the goal.

Once the robot knows where it is and it has a goal location, it can plan a path from the current
location to the goal location. This is generally done by a [global planner or planner for short](https://navigation.ros.org/concepts/index.html#planners).
There are many different algorithms for path planning each with their own advantages and disadvantages.
Most planners only plan a path, consisting of a number of waypoints, from the current location to
the goal location. More advanced planners can also provide velocity information along the path,
turning the path into a trajectory for the robot to follow. Once a path, or trajectory, is created
the robot can follow this path to reach the goal. For this a [local planner or controller](https://navigation.ros.org/concepts/index.html#controllers)
is used. The controller works to make the robot follow the path while making progress towards
the goal and avoiding obstacles. Again there are a number of different algorithms, each with it own
constraints.

Note that robot navigation is a very complex topic and there are many ways in which it can fail
or not work as expected. For example some of the issues I have seen are:

- Unable to find path to goal
    + Either the map isn't comnpletely known, or there is no actual way for the robot to get to the goal
          (maybe the gaps are too small for the robot to fit through)
- Unable to follow path. Generally the robot will get to the end but it won't follow the
  the original path
    + This can also lead to unnecessary in-place rotations
- Robot gets stuck in a corner / hallway. It considers the hallway / door frame too narrow to fit
  through safely. Sometimes this is caused by the robot being too wide. However most of the cases
  I have seen it in is caused by the planner configuration.

Now that we know roughly what is needed for successful navigation let's have a look at what is
needed for the swerve drive robot. The first thing we need is a way to figure out where we are. Because
I don't have a map of the environment I will be using an [online SLAM approach]().
For this I will be using the [slam_toolbox](https://github.com/SteveMacenski/slam_toolbox) package.

- SLAM setup
    + Can run in synchronous and asynchronous mode. Generally running async
    + Using the Cerses solver
    + Configuration file is [config/slam.yaml](https://github.com/pvandervelde/zinger_nav/blob/master/config/slam.yaml)
    + Using mostly the default configuration settings, except for the `base_frame` which has been
      adjusted to match the URDF model

- Nav setup
    + [MPPI](https://github.com/ros-planning/navigation2/tree/main/nav2_mppi_controller) for the controller / aka local planner
    + [SMAC lattice](https://github.com/ros-planning/navigation2/tree/main/nav2_smac_planner) for the planner / aka global planner
        - Using SMAC Lattice because we want a planner that supports omnidirectional movement for
          non-circular, arbitrary shaped robots
    + Originally tried the DWB controller and the navfn planner. Both are said to support omnidirectional
      movement. But when applied the DWB planner didn't really enable omnidirectional movement. Additionally
      it gets stuck for certain movements, but the DWB controller doesn't
      support omnidirectional movement, and the navfn planner doesn't support non-holonomic
      movement. This leads to the robot turning in wide circles instead of turning in place or
      moving sideways.

- Need a few different packages to get this to work
    + [zinger_description](https://github.com/pvandervelde/zinger_description) - Contains the URDF model
    + [zinger_ignition](https://github.com/pvandervelde/zinger_ignition) - Contains the configuration for Gazebo
    + [zinger_viz](https://github.com/pvandervelde/zinger_viz) - Contains the configuration for RViz
    + [zinger_swerve_controller](https://github.com/pvandervelde/zinger_swerve_controller) - Contains the actual movement controller
    + [zinger_nav](https://github.com/pvandervelde/zinger_nav) - Contains the SLAM and nav configuration

- To different ways to run the `zinger_nav` package
    + use the `slam.launch.py` to run the SLAM nodes
    + use the `nav2.launch.py` to run the Nav2 nodes

An example:

<iframe
    style="float:none"
    width="560"
    height="315"
    src="https://www.youtube.com/embed/U2IOLwuCvrQ"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
</iframe>

- 15 seconds in it starts sideways translating while rotating to get around the corner
- Translates sideways through the room at the end turning while moving to fit through the door opening
- It continues its journey mostly traversing sideways. At the end it rotates into the direction
  it was commanded to face once it got to the goal
- Note that the gobal planner inserted a turn, stop and back-up segment to get to the right orientation
  but the local planner opted to perform an inplace rotation at the end. (probably because it just
  drove to the end and then had to still turn)

Issues I've seen

- Robot not moving from the starting position. This was using the DWB controller. Not quite sure
  what is causing it
- Slow response to movement commands, leading to ever larger commanded steering and velocities.
  Mostly an issue with the DWB controller. The MPPI controller seems to be more responsive. However
  there is definitely an issue with the swerve controller part
- Found that the VM I was using wasn't quick enough to run the simulation close to real time. So at
  some point I need to switch to running on a desktop
