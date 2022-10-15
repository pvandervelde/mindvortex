Title: Starting robotics - Building a bumper for scuttle. The electronics
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

 ---

The final part of building a bumper for SCUTTLE is to assemble the electronics component which translate
the movement of the bumper into signals that inform the bumper software that an obstacle has been hit.



- Electronics design
    + Kicad image
        * Microswitch as trigger
        * LED that lights up when switch is pressed. This provides a visual indication that the sensor has engaged
        * Resistors on input pin in case something goes wrong in the software and uses it as an output pin (don't want to fry the LED)
        * Pull-down resistor to ensure that the pin is always low. Could do this in software but did it in hardware
          as an exercise
    + Send to board that joins signals from both switches, leave space for a rear bumper
    + Picked pins N ... M on the raspberry pi. Need a 3.3V pin, a ground pin and some GPIO pins, ideally all in the
      area. So picked the specific pins.
    + Creating a distribution board with JST female headers. Set it up so that we could have a bumper at the front
      and the back. Picked JST XH headers because the connectors are
- Pictures of the breadboard
- Picture of the circuit
- Testing set up on the breadboard
- Soldering the different boards
- Attaching the boards
- Final set-ups


- The software necessary to translate the microswitch signals to the BumperEvent message
    + GPIO for RPi. Make sure to reset all pins when you're done

- Learning to solder. Not very good at it at the moment.
- Learning to crimp connectors.
- Making electronics look good is hard


- Seeing some weird behaviour when an obstacle is encountered.
    + One motor turns and the other doesn't --> Deadband issues
    + One encoder is weird --> probably broken
    + The scuttle driver code is open loop. This might cause issues.