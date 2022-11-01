Title: Starting robotics - Fixing the wheel encoders
Tags:

- Robotics
- Scuttle
- Odometry
- Electronics

---

While testing the [bumper](posts/Robotics-a-bumper-for-scuttle-electronics) I noticed that when
reversing SCUTTLE would start a turn instead of driving straight backwards due to one motor turning
faster than the other motor. There are a number of reasons this could be happening, for instance
the driver code isn't properly commanding the motors, or the encoders are returning incorrect data,
etc..

The first thing I did for my investigation was to make sure my encoders provide sensible data. The
non-ROS SCUTTLE code contains a useful [Python script](https://github.com/scuttlerobot/SCUTTLE/blob/ce82a52ad025408a15f23f19c58add1321253783/software/python/basics/L1_encoder.py)
to measure the current value of the wheel encoders in a loop. I ran this code for a few minutes
while the wheels were stationary. In theory the results of this measurement should be two consistent
values, one for the left encoder and one for the right encoder. As you can see in the graph
it turns out that the angle measurement provided by the left encoder was very noisy.

<figure style="float:left">
<img alt="Encoder output for failing encode" src="/assets/images/robotics/scuttle/scuttle-encoder-fail.png" />
<figcaption>Encoder output for failing encoder</figcaption>
</figure>

While a noisy encoder shouldn't by itself cause the incorrect reversing pattern, it will make it more
difficult to find the actual cause of the problem. So before I address the bumper reversing behaviour
I needed to fix the encoder noise. The two main reasons for noisy encoder data that I could think of
were:

- The encoder is broken in some way. SCUTTLE uses the
  [AS5048A position sensor](https://nz.mouser.com/ProductDetail/ams-OSRAM/AS5048B-TS_EK_AB?qs=Rt6VE0PE%2FOduJIB%252BRfeBZQ%3D%3D)
  which is relatively robust, but can be broken if you send the I2c commands on the wrong pins. Which
  could happen if you say ... put the connector on the wrong way when assembling your SCUTTLE ...
- The distance between the encoder and the magnet on the motor shaft isn't correct. The specifications
  for the encoder state that the distance between the chip and the magnet on the motor shaft should
  be between 0.5mm and 2.5mm, assuming a magnet of the recommended size and strength is used.



- Possible reasons for not working (distance from sensor, broken sensor)
    + Trying to measure the distance between the sensor and the magnet. That is not easy because
    there is all kinds of stuff in the way
    + Measuring the brackets -> They're almost the same, but not quite, about 0.5mm difference
        * Possible need to sand the contact surfaces on the bracket
- swap the brackets --> Fixes it for some reason
    + Possibly due to a distance thing. Now both encoders are on the far end of what is allowed,but
      still within spec?
- Replace it with a new encoder
    + Encoder type + specs
    + Soldering the header pins


- Adding back to scuttle

- Testing the encoder

<figure style="float:right">
<img alt="Encoder output for functioning encoders" src="/assets/images/robotics/scuttle/scuttle-encoder-fixed.png" />
<figcaption>Encoder output for functioning encoders</figcaption>
</figure>

- Should improve odometry etc. but haven't tested that. Need to do a proper odometry test one day


The second issue is that the current SCUTTLE driver code is written as an open loop. This means
that there is no feedback to the motor control software that indicates how fast the wheels are
actually turning in response to a given motor input. And because even motors of the same type
are all slightly different, they all react differently to the same motor input. In my case at
low speeds one of my motors responds earlier than the other motor. In the end this means that
at low speeds the bumper code thinks scuttle is driving backwards in a straight line while it
is actually driving around in circles.
