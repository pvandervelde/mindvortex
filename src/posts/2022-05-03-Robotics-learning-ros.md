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
can quickly use. On the other hand drawback that comes with all of this is that the learning curve
for ROS is very steep. The documentation is pretty good and so are the tutorials, however there are
a lot of different parts in ROS, which makes for a lot of ways to get confused. So to speed up my
progress with ROS I decided to do the [ROS for beginners I](https://www.udemy.com/course/ros-essentials/)
and [II courses](https://www.udemy.com/course/ros-navigation/) on Udemy. These courses were very helpful
to reduce the learning curve for ROS and quickly get me familiar with ROS.

<figure style="float:left">
<img alt="Scuttle in Gazebo" src="/assets/images/robotics/scuttle/scuttle-in-gazebo.jpg" />
<figcaption>SCUTTLE robot in Gazebo</figcaption>
</figure>

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
compute devices, it is possible to run ROS distributed over the network. This is the way I currently
run ROS.

<figure style="float:right">
<img alt="Scuttle in RViz" src="/assets/images/robotics/scuttle/scuttle-in-rviz-no-sensors.jpg" />
<figcaption>SCUTTLE robot in RViz</figcaption>
</figure>

Once you have a working ROS installation the next thing you'll find out is that ROS configurations
can be difficult to get right, especially when you're working with a physical robot where visibility
of what is going on may not be the best. There are a number of useful tools available to provide
insights into what is going on with your robot.

The first tool is [Gazebo](https://gazebosim.org/) which provides a simulated environment for
ROS robots. The simulation is based on a physics engine with good accuracy of real world physics. It
also provides models for sensors, like LIDAR and cameras, and sensor noise to simulate real-world
sensor behaviour. Having a simulated environment allows you to repeat behaviours many times in
the same way in rapid succession. Having a way to easily repeat behaviours and control the environment
means that you can quickly test and debug specific behaviours, something which can be much more difficult
with a physical robot.

The second tool, [RViz](http://wiki.ros.org/rviz), provides visualization of the environment of the
robot and how the robot perceives that environment. It allows you to visualize what the robot can
'see'. RViz works by subscribing to the different message topics that are available. This means
it works both for simulated robots (using Gazebo) and physical robots.

The final tool worth discussing is [Foxglove studio](https://foxglove.dev/) which also provides
insight into the data that the robot generates, both from sensors but also in the form of messages
sent between the different components of the robot. One of the nice features of Foxglove is that
you can make plots with values provided by messages. For instance you can plot the velocity
components of a [Twist message](http://docs.ros.org/en/lunar/api/geometry_msgs/html/msg/Twist.html).
This is useful to compare requested velocities compared to actual achieved velocities.
Another great feature of Foxglove is that it is able to display the [ROS logs](http://wiki.ros.org/rosout)
and it also allows you to filter and search these logs. Given that ROS logs can quickly become
large the ability to filter is very useful.

<figure style="float:left">
<img alt="Scuttle in RViz with LIDAR overlay" src="/assets/images/robotics/scuttle/scuttle-in-rviz-slam-enabled.jpg" />
<figcaption>SCUTTLE robot in RViz with LIDAR overlay</figcaption>
</figure>

When working with a mobile robot, like I am, getting the robot to navigate a space is often one of
the first achievable goals. The [navigation stack](http://wiki.ros.org/navigation) in ROS provides
a lot of the basic capabilities to get started with robot navigation in a reasonable time span. Do
note however that the navigation stack in ROS is fairly large and has a lot of different configuration
options so it is wise to set some time aside for learning about the different options. I'll talk about
navigating with SCUTTLE in a future post.

As mentioned I started learning ROS1 with Udemy. My goal for learning ROS was to use it for
navigation with my SCUTTLE  robot, more on that in a future post. Once I manage to get navigation
working for SCUTTLE I plan to start adding different sensors. Finally I want to enable task planning
for SCUTTLE, e.g. tasks like "drive to the living room and collect my coffee cup and bring it back
to me".

Another part of my plans is to upgrade to using [ROS2](https://docs.ros.org/en/galactic/index.html).
ROS1 end-of-life is 2025, which is only 3 years away, and additionally ROS2 has a more modern stack
with python 3, better communication security, an improved navigation stack and more active development.
More on this will follow in a future post once I have upgraded my robot to ROS2
