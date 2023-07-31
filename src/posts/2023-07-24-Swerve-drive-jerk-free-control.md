Title: Swerve drive - Jerk free movements
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---

In the last few posts I have described the simulations I did of a robot with a swerve drive. In
other words a robot with four wheels each of which is independently driven and steered. I did
simulations for the case where we specified movement commands [directly for the drive modules](https://youtu.be/LlyopmLMlZY)
and one for the case where we specified movement commands for [the robot body](https://youtu.be/U6Z_meFKNrI).
One of the things you can see in both simulations is that the motions is quite 'jerky', i.e. with
sudden changes of velocity or acceleration. In real life this kind of change would be noticed by
humans as shocks which are [uncomfortable and can potentially cause injury](https://en.wikipedia.org/wiki/Jerk_(physics)#Physiological_effects_and_human_perception).
In machinery a jerky motion adds load to the equipment which can cause failures. So for both humans
and equipment it is sensible to keep the 'jerkiness' as low as possible.

In order to achieve this we first need to understand what jerk actually is. Once we understand it
we can figure out ways to control it. In physics Jerk is defined as the change of acceleration
with time, i.e the first time derivative of acceleration. So jerk vector as a function of time,
<la-tex>\vec{{j}}(t)</la-tex> can be defined as:

<p>
  <la-tex class="block">
    \vec{j}(t) = \frac{d\vec{a}(t)}{dt} = \frac{d^{2}\vec{v}(t)}{dt^{2}} = \frac{d^{3}\vec{r}(t))}{dt^{3}}
  </la-tex>
</p>

Where

- <la-tex>t</la-tex> is time
- <la-tex>\frac{{d}}{{dt}}</la-tex>, <la-tex>\frac{{d}}{{dt^{2}}}</la-tex>, <la-tex>\frac{{d}}{{dt^{3}}}</la-tex>
  are the [first](https://en.wikipedia.org/wiki/Time_derivative), [second](https://en.wikipedia.org/wiki/Second_derivative)
  and [third](https://en.wikipedia.org/wiki/Third_derivative) time derivative
- <la-tex>\vec{{a}}</la-tex> is the acceleration vector
- <la-tex>\vec{{v}}</la-tex> is the velocity vector
- <la-tex>\vec{{r}}</la-tex> is the position vector

From these equations we can for instance deduce that a linearly increasing acceleration is caused by
a constant jerk value. And a constant jerk value leads to a quadratic behaviour in the velocity. A
more interesting deduction is that an acceleration that changes from a linear increase to a constant
value means that there must be a discontinuous change in jerk. After all a linear increasing acceleration
is caused by a constant positive jerk, and a constant acceleration is achieved by a zero jerk. Where
these two acceleration profiles meet there must be a jump in jerk. This is demonstrated in the plot below.

With that you can probably imagine what happens if the velocity has a change from a linearly increasing
value to a constant value. The acceleration drops from a positive constant value to zero. And the
jerk value displays spikes when the acceleration changes.

<figure style="float:left">
  <a href="/assets/images/robotics/control/acceleration_and_jerk_for_s-curve_motion_profile.png" target="_blank">
    <img
        alt="Acceleration and jerk curves for the s-curve motion profile"
        src="/assets/images/robotics/control/acceleration_and_jerk_for_s-curve_motion_profile.png"
        width="800"/>
  </a>
  <figcaption>Acceleration and jerk plots for the s-curve motion profile.</figcaption>
</figure>

So in order to move a robot, or robot part, from one location to another in a way that the jerk
values stay manageable we need to control the velocity and acceleration across time. This is normally
done using a motion profile which describes how the velocity and acceleration change over time in
order to arrive at the new state at the desired point in time. Two of the most well
known motion profiles are the trapezoidal profile and the s-curve profile.

<figure style="float:left">
  <a href="/assets/images/robotics/control/velocity_and_acceleration_and_jerk_for_trapezoidal_and_s-curve_motion_profiles.png" target="_blank">
    <img
        alt="Velocity, acceleration and jerk curves for the trapezoidal and s-curve motion profiles"
        src="/assets/images/robotics/control/velocity_and_acceleration_and_jerk_for_trapezoidal_and_s-curve_motion_profiles.png"
        width="800"/>
  </a>
  <figcaption>Velocity, acceleration and jerk plots for the trapezoidal and s-curve motion profiles.</figcaption>
</figure>

### The trapezoidal motion profile

The trapezoidal motion profile consist of three distinct phases. During the first phase a constant
positive acceleration is applied. This leads to a linearly increasing velocity until the maximum
velocity is achieved. In the second phase no acceleration is applied keeping the velocity constant.
Finally in the third phase a constant negative acceleration is applied, leading to a decreasing
velocity until the velocity becomes zero.

The equations for the different phases are as follows

#### Phase 1

<p>
  <la-tex class="block">
    a_1(t) = a_{max}
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_1(t) = v_0 + a_1 t = 0 + a_{max} t = a_{max} t
  </la-tex>
</p>
<p>
  <la-tex class="block">
    r_1(t) = r_0 + v_0 t + \frac{1}{2} a_1 t^2 = 0 + 0 t + \frac{1}{2} a_{max} t^2 = \frac{1}{2} a_{max} t^2
  </la-tex>
</p>

Where

- <la-tex>t</la-tex> is time between zero and the time at the end of phase 1.
- <la-tex>a_{{max}}</la-tex> is the maximum positive acceleration.
- <la-tex>v_0</la-tex> is the initial velocity. Generally zero.
- <la-tex>r_0</la-tex> is the initial position. Generally taken to be zero.

#### Phase 2

<p>
  <la-tex class="block">
    a_2(t) = 0
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_2(t) = v_1 + a_2 t = a_{max} t_1 + 0 (t - t_1) = a_{max} t_1
  </la-tex>
</p>
<p>
  <la-tex class="block">
    r_2(t) = r_1 + v_1 t + \frac{1}{2} a_2 t^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1) + \frac{1}{2} 0 (t - t_1)^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1)
  </la-tex>
</p>

Where

- <la-tex>t</la-tex> is time between zero and the time at the end of phase 2.
- <la-tex>t_{{1}}</la-tex> is the time at the end of phase 1.

#### Phase 3

<p>
  <la-tex class="block">
    a_3(t) = -a_{max}
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_3(t) = v_2 + a_3 t = a_{max} t_1 - a_{max} (t - t_2)
  </la-tex>
</p>
<p>
  <la-tex class="block">
      r_3(t) = r_2 + v_2 t + \frac{1}{2} a_3 t^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1) + a_{max} t_1 (t - t_2) - \frac{1}{2} a_{max} (t - t_2)^2
  </la-tex>
</p>


#### My implementation

To create a trapezoidal motion profile for my swerve drive simulation I looked at the two extremes
in velocity, which are:

 - A constant velocity over the entire time span. This essentially assumes infinite acceleration at
   the start and infinite deceleration at the end of the profile. In this case the velocity is defined
   as <la-tex>v_{{min}} = \frac{{end_position - start_position}}{{t}}</la-tex>
- A constant acceleration over the first half of the timespan, followed by a constant deceleration
  for the second half of the timespan. In this case the velocity is defined as
  <la-tex>v_{{max}} = 2 * \frac{{end_position - start_position}}{{t}}</la-tex>

Initially I have assumed that the different stages of the profile all take the same amount of time,
i.e. one third of the total time. In real life this may not be true because the amounts of time
spend in the different stages depend on the maximum reachable acceleration and velocity as well as
the minimum and maximum time in which the profile needs to be achieved.

Additionally my motion profile code assumes that the motion profile
is stored for a relative timespan of 1 unit of time. If I want a different timespan I can just multiply
by the desired timespan to get the final result.

With these assumptions I get a minimum velocity as given above, and a maximum velocity of twice
the minimum velocity.

For a trapezoidal motion profile where each stage is 1/3 of the time we can now determine what
velocity we need to move at by using the

<p>
  <la-tex class="block">
    s = 0.5 * v * t_{accelerate} + v * t_{constant} + 0.5 * v * t_{decelerate}
  </la-tex>
</p>

<p>
  <la-tex class="block">
    s = v * 2/3 * t
  </la-tex>
</p>

<p>
  <la-tex class="block">
    v = 1.5 * \frac{s}{t}
  </la-tex>
</p>

- trapezoidal is a lot better than a linear profile. It is second order in position giving it a much
  smoother behaviour.
- Jerk spikes are smaller than with the linear profile. However there are still jerk spikes
- So we'd still need a better motion profile if we want to control the jerk spikes even more

### The s-curve motion profile

The s-curve motion profile consist of seven distinct phases:

- Phase 1: Constant positive jerk, linearly increasing acceleration, velocity increasing following
  a second order curve.
- Phase 2: Zero jerk, constant acceleration, velocity increasing linearly.
- Phase 3:Constant negative jerk, linearly decreasing acceleration, stopping at zero, velocity still
  increasing, following a second order curve to a constant velocity value
- Phase 4: Zero jerk, zero acceleration, constant velocity.
- Phase 5: Constant negative jerk, linearly decreasing acceleration, velocity decreasing following
  a second order curve.
- Phase 6: Zero jerk, constant negative acceleration, velocity decreasing linearly.
- Phase 7: Constant positive jerk, linearly increasing acceleration until the acceleration is zero,
  velocity still decreasing following a second order curve, until the velocity is zero.

This motion profile is piece-wise linear for acceleration, piece-wise quadratic for velocity and
piece-wise cubic for position.


#### Phase 1

<p>
  <la-tex class="block">
    j_1(t) = j_{max}
  </la-tex>
</p>
<p>
  <la-tex class="block">
    a_1(t) = a_0 + j_{1} t = 0 + j_{max} t
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_1(t) = v_0 + a_1 t + \frac{1}{2} j_1 t^2 = STUFF
  </la-tex>
</p>
<p>
  <la-tex class="block">
    r_1(t) = r_0 + v_0 t + \frac{1}{2} a_1 t^2 = 0 + 0 t + \frac{1}{2} a_{max} t^2 = \frac{1}{2} a_{max} t^2
  </la-tex>
</p>

Where

- <la-tex>t</la-tex> is time between zero and the time at the end of phase 1.
- <la-tex>a_{{max}}</la-tex> is the maximum positive acceleration.
- <la-tex>v_0</la-tex> is the initial velocity. Generally zero.
- <la-tex>r_0</la-tex> is the initial position. Generally taken to be zero.

#### Phase 2

<p>
  <la-tex class="block">
    a_2(t) = 0
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_2(t) = v_1 + a_2 t = a_{max} t_1 + 0 (t - t_1) = a_{max} t_1
  </la-tex>
</p>
<p>
  <la-tex class="block">
    r_2(t) = r_1 + v_1 t + \frac{1}{2} a_2 t^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1) + \frac{1}{2} 0 (t - t_1)^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1)
  </la-tex>
</p>

Where

- <la-tex>t</la-tex> is time between zero and the time at the end of phase 2.
- <la-tex>t_{{1}}</la-tex> is the time at the end of phase 1.

#### Phase 3

<p>
  <la-tex class="block">
    a_3(t) = -a_{max}
  </la-tex>
</p>
<p>
  <la-tex class="block">
    v_3(t) = v_2 + a_3 t = a_{max} t_1 - a_{max} (t - t_2)
  </la-tex>
</p>
<p>
  <la-tex class="block">
      r_3(t) = r_2 + v_2 t + \frac{1}{2} a_3 t^2 = \frac{1}{2} a_{max} t_1^2 + a_{max} t_1 (t - t_1) + a_{max} t_1 (t - t_2) - \frac{1}{2} a_{max} (t - t_2)^2
  </la-tex>
</p>

#### Phase 4

#### Phase 5

#### Phase 6

#### Phase 7

EQUATIONS -> much more complicated. Need to go to the jerk level

- Jerk spikes are lower than for linear or trapezoidal
- Third order in position, very smooth


So having these motion profiles, what are the results for the behaviour of the swerve drive robot


- What effect does this have on the behaviour of the swerve drive robot?
  - With linear motion profiles the jerk spikes are quite large. Using body driven control reduces
    the jerk levels for the drive modules when compared to module driven control. However for both
    body and module level control the jerk spikes are high.
    - For the linear profile there are large acceleration spikes for the module steering angle
      behaviour, but only for the module control approach. In the body control approach the
      behaviour of the module steering angle is much smoother
  - The trapezoidal profile significantly decreases the maximum value of the acceleration and jerk
    spikes
    - Reduction of jerk spike levels by a factor of 10 - 15
    - More effect in the module driven control. This is possibly due to the fact that the module
      steering and drive behaviour is pretty smooth under body driven control
  -


- One issue is the fact that low-jerk generally means higher max/min velocities and accelerations
  because more of the profile is spend transitioning smoothly from one state to another
    + That ironically leads to higher accelerations and jerk values (because there is less time)



- Is there anything better than s-curve
  - Yes, you can go to 4th, 5th order or even higher. Generally engineers stop at 5th order
    which is 2nd order in the jerk profile
  - I haven't implemented any higher order motion profiles yet. Maybe one day

- One issue is that the motion profiles will quite happily command velocities, accelerations and jerks
  that the motors cannot deliver. So you need to include motor limits.

- For swerve it gets even more interesting because we want to use body oriented control in order to
  keep the modules synchronised, but that means that the module profiles need to be synchronised
  and also need to be low-jerk. So how do we do that.
  - This is where the big guns come in. Lots of nasty math: ICR synchronization paper: Motion Discontinuity-Robust Controller for Steerable Mobile Robots

- Also the next step is to do path tracking, because path tracking adds time pressure
  and velocity + orientation

- Suggested that I would find ways to reduce the jerk. Note that you can't have jerk-free
  motion, because in order to change position, or change velocity you have to accelerate
  and decelerate and that causes some form of jerk. You can however reduce the maximum / minimum
  jerk levels and reduce rapid changes in jerk levels.
