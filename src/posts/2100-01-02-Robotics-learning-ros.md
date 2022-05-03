Title: Starting robotics - Learning Robot Operating System (ROS)
Tags:

- Robotics
- ROS
- ROS Noetic

---

As part of my [journey into robotics](tags/Robotics) I have been working on updating my
[SCUTTLE robot](https://www.scuttlerobot.org/) to use the
[Robot Operating System (ROS)](http://wiki.ros.org/). ROS provides a number of different things
that make robot development much easier. The main items are a middleware layer for communication
between different parts of the robot, hardware abstractions for different sensors, motors and
controllers, device drivers and many other libraries and packages.

The main benefit of using ROS is that it provides a lot of integrations and functionality that you
can quickly use. The drawback is that the learning curve for ROS is very steep. The documentation is
pretty good and so are the tutorials, however there are a lot of different parts in ROS which makes
for a lot of ways to get confused. So to speed up my progress with ROS I decided to do the
[ROS for beginners I](https://www.udemy.com/course/ros-essentials/) and
[II courses](https://www.udemy.com/course/ros-navigation/) on Udemy. These courses were very helpful
to flatten the learning curve for ROS and quickly get me familiar with ROS.

This post won't explain how ROS works, there are
[many, many, many tutorials out on the web](https://www.google.com/search?q=getting+started+with+ros&rlz=1C1CHBF_enNZ825NZ825&oq=getting+started+with+ros&aqs=chrome..69i57j69i61.2633j0j7&sourceid=chrome&ie=UTF-8)
that will do a far better job than I can. However I do want to share some of the things I learned
from working with ROS.

The first thing to note is the operating system on which you want to run ROS. ROS is developed
to be run on Ubuntu. My home PC runs on the Windows Operating System. ROS 1 wasn't designed to run
directly on Windows (ROS2 will be able to) but there are several ways to run it. First you can run
ROS Noetic straight on Windows using [Robostack](https://robostack.github.io/). This uses the Conda
package manager and provides packages for all operating systems. I found that this works moderately
well, there are a number of packages missing and occasionally things error out. This approach works
well for simple learning exercises but may yet not be suitable for large ROS applications.

A second approach is to [run ROS on WSL2](https://ishkapoor.medium.com/how-to-install-ros-noetic-on-wsl2-9bbe6c00b89a).
This is able to run the Ubuntu native packages so you can run all parts of ROS and with the help of
an XServer like [VcXsrv](https://sourceforge.net/projects/vcxsrv/) you can even run all the graphical
tools. One thing to keep in mind if you use WSL is that networking may cause problems if you run
ROS distributed over more than one computing device, e.g. a laptop and a physical robot. With WSL
there is no easy way to expose WSL applications to uninitiated network connections, i.e.
a request started from inside WSL works, but a request started from outside WSL won't be able to
connect. This is important because ROS nodes need to be able to communicate with each other freely.
The result will be that the nodes on the WSL side will seem to be connected and functional while the
other nodes won't be able to send messages to the WSL nodes.

The final approach to running ROS is to create an [Ubuntu VM](https://gist.github.com/pvandervelde/2282dafc080945ecb7981edb740ed47c)
or physical machine. In this case as long as the machine is reachable over the network for other
compute devices, it is possible to run ROS distributed over the network.

After having tried all three approaches I am currently using an Ubuntu 20.04 VM with ROS Noetic
installed as this provided the most natural way to run ROS (on Ubuntu) and have good networking.

<figure style="float:left">
<img alt="Scuttle in Gazebo" src="/assets/images/robotics/scuttle/scuttle-in-gazebo.png" />
<figcaption>SCUTTLE robot in Gazebo</figcaption>
</figure>

Once you have a working ROS installation the next thing you'll find out is that debugging ROS can
be difficult, especially when you're working with a physical robot. There are a number of useful
tools available to provide insights into what is going on. [RViz](http://wiki.ros.org/rviz) is a
3D visualizer for ROS. It provides insights into the environment of the robot and how it perceives
the environment.


         PICTURE OF SCUTTLE IN RVIZ


A similar tool is [Foxglove studio](https://foxglove.dev/) which also provides a way to process
the data send between different ROS nodes.


- Foxglove studio is useful but doesn't replace RViz

- Debugging: Setting debug level logs


        PICTURE OF FOXGLOVE

Navigation is often one of the first achievable goals

- The navigation stack is big and requires lots of learning. More posts about that will undoubtedly
  be posted later.
  - Navigation in ROS1 consists requires a global planner, takes the map and determines a path
    from the current location to the goal, and local planner, which moves the robot towards the
    goal and tries to follow the path planned by the global planner

- Turtlebot3 is a good example of how to set things up, but remember that it was created a while
  ago and ROS is evolving.

- Configuration for the nav stack is big



Approaches for the next steps

- Aiming to learn ROS1 (noetic) first as there's lots of example material around. Then switching
  to ROS2 as it has a more modern stack (better security, faster, better nav stack etc.). And more
  active development

- The ROS 1 navigation stack assumes you have a Lidar or similar way of getting object distances. It
  looks that the ROS2 navigation stack is a little more flexible

- Default ROS nav is path planning, a route from A to B, but it doesn't prescribe velocities /
  acceleration along the path. For that you need trajectory planner. Drone path planning is
  often done in trajectory planning, prescribing both velocity and accelerations along the path to
  ensure the most smooth path
