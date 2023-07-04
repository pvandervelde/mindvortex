Title: Swerve drive - Movement animations
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

In my last two posts I talked about different control methods for a swerve drive robot. One method
controls the movement of drive modules directly. The other method controls the movement of
the body and derives the desired state for the drive modules from that.

<figure style="float:middle">
  <a href="/assets/images/robotics/swerve/swerve_sim_45_linear_to_inplace_rotation.png" target="_blank">
    <img
        alt="45 degree linear track to in-place rotation"
        src="/assets/images/robotics/swerve/swerve_sim_45_linear_to_inplace_rotation.png"
        width="840"
        height="368"/>
  </a>
  <figcaption>Simulation data for a 45 degree linear track that transitions to an in-place rotation.</figcaption>
</figure>

To see the difference between these control methods my simulation code created all kinds of interesting
plots like the ones above. However I was still having trouble visualizing what was actually happening,
especially in the case of the movement of the Instantaneous Centre of Rotation (ICR), i.e. the
rotation point for the robot at a given point in time. The lower left graph shows the paths the
ICR for different combinations of drive modules. While it looks pretty it does not make a lot of
sense to me.

<iframe
    style="float:left"
    width="560"
    height="315"
    src="https://www.youtube.com/embed/LlyopmLMlZY"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
</iframe>

So to address that issue I updated the simulation code to produce some animations that display the
position of the robot and the wheels as well as a number of plots for the state of the robot body
and the drive modules. The following animation shows how the robot behaves when using the
[direct module controller](posts/Swerve-drive-kinematics-simulation). As you can see in the video different
pairs of wheels have different rotation points, signified by the red dots. As the movement progresses
these rotation points have quite a large range of motion. This indicates that the wheels are not
synchronized and most likely some of the wheels are slipping.

I created another animation for the same situation but with the
[body oriented controller](posts/Swerve-drive-body-focussed-control). In this case the rotation points
are all in a single location leading me to conclude that all the wheels are synchronized and little
to no wheel slip is occurring.

<iframe
    style="float:right"
    width="560"
    height="315"
    src="https://www.youtube.com/embed/U6Z_meFKNrI"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
</iframe>

One other interesting thing you can see in the video is that the acceleration and
[jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) values change very abruptly. In real life this
would lead to significant loads on the robot and its drive system. In the simulation this behaviour
is due to the fact that linear profile that is being used to transition from one state to another.
As mentioned before the next improvement will be to replace this linear interpolation with a control
approach that will provide [smooth transitions](https://en.wikipedia.org/wiki/Jerk_(physics)#In_motion_control)
for velocity and accelerations.
