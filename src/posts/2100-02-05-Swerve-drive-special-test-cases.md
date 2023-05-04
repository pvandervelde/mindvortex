Title: Swerve drive - Special test cases
Tags:

- Robotics
- Swerve
- Omnidirectional
- Kinematics

---



- start: all modules aligned, moving forwards. end: all modules aligned moving backwards
- start: all modules aligned, moving forwards. end: all modules aligned moving sideways
- start: velocity = 0, rotation != 0. end: velocity = 0, rotation != 0. rotation_start != rotation_end
- start: velocity = 0, rotation != 0. end: velocity = 0, rotation != 0. rotation_start = -rotation_end
- start: velocity != 0, rotation != 0. end: all stop
- start: all stop. end: velocity != 0, rotation != 0
- start: velocity != 0, rotation = 0. end: velocity != 0, rotation = 0. velocity_start != velocity_end
- start: velocity = 0, rotation != 0. end: velocity != 0, rotation = 0
- start: velocity != 0, rotation = 0. end: velocity = 0, rotation != 0
- rotation around wheel


Algorithms tested



Conclusions from the simulations

- ??
