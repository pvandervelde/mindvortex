Title: Swerve drive - Using Nav2
Tags:

- Robotics
- Swerve
- Omnidirectional
- ROS2
- Nav2
- Zinger

---

The [goals for the development of my swerve drive robot](/posts/Swerve-drive-introduction) were to
develop an off-road capable robot that can navigate autonomously between different locations to
execute tasks either by itself or in cooperation with other robots. So far I have implemented the
first version of the [steering and drive controller](/posts/Swerve-drive-body-focussed-control),
added [motion profiles](/posts/Swerve-motion-profiles) for smoother changes in velocity and acceleration,
and I have created the [URDF files](/posts/Robotics-making-urdf-models) that allow me to simulate the
robot in Gazebo. The next part is to add the ability to navigate the robot, autonomously,
to a goal location.

So how does the navigation in general work? The first step is to figure out where the robot is, or
at least what is around the robot. Using the robot sensors, e.g. a lidar, we can see what the direct
environment looks like, e.g. the robot is in a room of a building. If we have a map of the larger
environment, e.g. the building, then using a [location algorithm](https://github.com/ros-planning/navigation2/tree/main/nav2_amcl)
we can figure out where in the building we are. Assuming there are enough features in the
room to make it obvious which room we are in. If we don't have a map of the environment then we can
use a [SLAM](https://en.wikipedia.org/wiki/Simultaneous_localization_and_mapping) algorithm to create
a map while the robot is moving. Having a map makes planning more reliable, because we can plan a
path that takes into account the surroundings. However it is not strictly necessary, we can also
plan a path without a map, but then it is possible that the planner will plan a path that is not
possible to follow, e.g. because there is a wall in the way. Of course if there are dynamic obstacles,
e.g. if a door is closed, then the map might not be accurate and we might still not be able to get
to the goal.

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

Note that robot navigation is a very complex topic that is very actively being researched. A result
of this is that there are many ways in which navigation can fail or not work as expected. For example
some of the issues I have seen are:

- The planner is unable to find a path to the goal. This can happen when there is no actual way to
  get to the goal, e.g. the robot is in a room with a closed door with the goal outside the room.
  Or when the path would pass through a section that is too narrow for the robot to fit through.
- The controller is unable to follow path created by the planner, most likely because the path is not
  kinematically possible for the robot. For example the path might require the robot to turn in place
  when it is using an Ackerman steering system. Or the path requires the robot to pass through a
  narrow space that the controller deems to narrow.
- The robot gets stuck in a corner or hallway. It considers the hallway too narrow to fit
  through safely or has no way to perform the directional changes it wants to make. Sometimes this is
  caused by the robot being too wide. However most of the cases I have seen it in is caused by the
  planner configuration.
- The robot is slow to respond to movement commands, leading to ever larger commanded steering and velocities.
  This was mostly an issue with the DWB controller, the MPPI controller seems to be more responsive.
  However there is definitely an issue with the swerve controller code that I need to investigate.
- The VM I was running the simulation on wasn't quick enough to run the simulation close to real time.
  So at some point I need to switch to running on a desktop.

And these are only the ones I have seen. There are many more ways in which the navigation can fail.
So it pays to stay up to date with the latest developments and to ensure that you have good ways
to test and debug your robot and the navigation stack.

Now that we know roughly what is needed for successful navigation let's have a look at what is
needed for the swerve drive robot. The first thing we need is a way to figure out where we are. Because
I don't have a map of the environment I am using an online SLAM approach, which creates the map
as the robot moves around the area. The [slam_toolbox](https://github.com/SteveMacenski/slam_toolbox)
package makes this easy. The  [configuration](https://github.com/pvandervelde/zinger_nav/blob/master/config/slam.yaml)
for the robot is mostly the default configuration, except for the changes required to match the URDF
model.

For the navigation I am using the [Nav2](https://navigation.ros.org/) package. From that package I
selected the [SMAC lattice](https://github.com/ros-planning/navigation2/tree/main/nav2_smac_planner)
for the planner and the [MPPI](https://github.com/ros-planning/navigation2/tree/main/nav2_mppi_controller)
controller. These two were selected because they both support omnidirectional movement for non-circular,
arbitrary shaped robots. The omnidirectional movement is required because the swerve drive robot
can move in all directions and it would be a waste not to use that capability. The non-circular robot
comes from the fact that the robot is rectangular and could pass through narrow passages in one
orientation but not the other. Originally I tried the
[DWB controller](https://github.com/ros-planning/navigation2/tree/main/nav2_dwb_controller)
and the [navfn planner](https://github.com/ros-planning/navigation2/tree/main/nav2_navfn_planner).
Both are said to support omnidirectional movement. But when applied the DWB planner didn't really
use the omnidirectional capabilities. Additionally it gets stuck for certain movements for unknown
reasons. Once I changed to using the SMAC planner and the MPPI controller the robot was successfully
able to navigate around the environment.
Again the [configuration](https://github.com/pvandervelde/zinger_nav/blob/master/config/nav2.yaml)
is mostly the default configuration except that I have updated some of the values to match the robot's
capabilities.

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

With all that set I got the robot to navigate to a goal. The video shows the robot starting the navigation
from one room to another. As it moves at the [15 second](https://youtu.be/U2IOLwuCvrQ?t=15) mark it
starts sideways translating while rotating to get around the corner in order to get through the door
of the room. It continues its journey mostly traversing sideways, occasionally rotating into the
direction it is moving. At the [52 second](https://youtu.be/U2IOLwuCvrQ?t=52)
mark it reaches the goal location and rotates into the orientation it was commanded to
end up in. Note that the planner inserted a turn, stop and back-up segment to get to the right
orientation but the local planner opted to perform an in-place rotation at the end.

While there was a bit of tuning required to get the SLAM and navigation stacks to work, in the
end it worked well. Obviously this is only one test case so once I have a dedicated PC to run
the simulation I am going to do a lot more testing.

One of the things that is currently not implemented is limits on the steering and drive velocities.
This means that currently the robot can move at any speed and turn at any rate. This is not
realistic and will in the real world lead to the motors in the robot being overloaded. So the
next step is to add the limits to the controller. The main issue with this is the need to keep the
drive modules synchronised. So when one of the modules exceeds its velocity limits the other modules
have to be slowed down as well so that we don't lose synchronisation between the modules. More on this
in one of my next posts.
