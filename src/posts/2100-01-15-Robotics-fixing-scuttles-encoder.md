Title: Starting robotics - Fixing the wheel encoders
Tags:

- Robotics
- Scuttle
- Odometry
- Electronics

---

- One of the encoders on SCUTTLE has gone bad, probably because I broke it
- Showed weird behaviour when testing the bumper code on scuttle
- Running a test with the encoder python code to get the numbers
- Collect data for a while --> plot it in a graph. One of the encoders is steady, the other is not

PICTURE OF THE SCATTER

- Possible reasons for not working (distance from sensor, broken sensor)
    + Trying to measure the distance between the sensor and the magnet. That is not easy because
    there is all kinds of stuff in the way
    + Measuring the brackets -> They're almost the same, but not quite, about 0.5mm difference
        * Possible need to sand the contact surfaces on the bracket
- Replace it with a new encoder
    + Encoder type + specs
    + Soldering the header pins
- swap the brackets --> Fixes it for some reason
    + Possibly due to a distance thing. Now both encoders are on the far end of what is allowed,but
      still within spec?

- Adding back to scuttle

- Testing the encoder

PICTURE OF THE NOT SCATTER

- Should improve odometry etc. but haven't tested that. Need to do a proper odometry test one day


The second issue is that the current SCUTTLE driver code is written as an open loop. This means
that there is no feedback to the motor control software that indicates how fast the wheels are
actually turning in response to a given motor input. And because even motors of the same type
are all slightly different, they all react differently to the same motor input. In my case at
low speeds one of my motors responds earlier than the other motor. In the end this means that
at low speeds the bumper code thinks scuttle is driving backwards in a straight line while it
is actually driving around in circles.
