Title: Swerve drive - Moving a robot in all directions, mostly
Tags:

- Robotics
- Swerve
- Omnidirectional

---

- What is a swerve drive - all wheel drive + all wheel steering. Done with 3 or more wheels
  - Often done with 4 wheels, but 3 wheel variants exist, and so do 6 or 8 wheel variants.
  - Full swerve has infinite rotation for the steering part of the drive, i.e. the wheel can
    rotate around its steering axis infinitely without getting stuck
    - Some swerve drives are limited to a few rotations due to the construction (often electrical
      wire running down to the wheel motor)
- What are they good for
  - Full carry capacity. Omni-wheels have the same degree of freedom but can often not carry the
    same load
  - High degree of freedom. Rotation around any point possible including around an axis,
    translation in any direction at maximum velocity, including sideways
  - Allows for high degree of position accuracy (although this needs to be backed up by
    suitable structure, electrical and software)
  - Lower friction in all modes of movement when compared to omni-wheels
  - Ability to traverse rough terrain as the chassis is suspended on normal wheels

- What are they not good for
  - More complex system, mechanically, electrically and in kinematics
  - Harder to code. Lots more variables
  - The mechanics / electrics need to be such that the wheels do not get out of
    sync. Any difference in steering angle from the desired angle will create
    excess friction / wear
  - More failure modes