Title: Starting robotics - Building a bumper for scuttle. The electronics
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

 ---

- Electronics design
    + Kicad image
        * Microswitch as trigger
        * LED that lights up when switch is pressed. This provides a visual indication that the sensor has engaged
        * Resistors on input pin in case something goes wrong in the software and uses it as an output pin (don't want to fry the LED)
        * Pull-down resistor to ensure that the pin is always low. Could do this in software but did it in hardware
          as an exercise
    + Send to board that joins signals from both switches, leave space for a rear bumper

- Pictures of the breadboard
- Picture of the circuit
- Testing set up
- Final set-ups



- Physical bumper
    + Use ROSSerial to send bumper messages
    + Use the same node as in virtual to respond to bumper messages
    + GPIO for RPi. Make sure to reset all pins when you're done

- Learning to solder