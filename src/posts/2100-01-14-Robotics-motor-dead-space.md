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