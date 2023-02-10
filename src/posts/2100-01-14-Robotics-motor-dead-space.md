Title: Starting robotics - Motor dead spots
Tags:

- Robotics
- Scuttle
- Electronics

---

- The motors on SCUTTLE have fairly sizable dead spots
- That means for certain low PWM cycles the motors will get power but won't turn the wheels
- It's different per motor, so hard to correct with static code
- Ideally you need a closed loop motor controller, but at the moment SCUTTLE doesn't have one
- PID might work but doesn't necessarily deal well with systems that are discrete or have large variations
    + Also PID settings might be unique to the specific combination of motors and controllers
