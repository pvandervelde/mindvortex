Title: Starting robotics - Building a bumper for scuttle
Tags:

- Robotics
- ROS
- ROS Noetic
- Scuttle

---

- My first piece of electronics / addition to scuttle
- A bumper that will tell scuttle if it has hit something
- Bumpers are really a last resort sensor

- CAD image for assembly

- Kicad image

- Bumper in Gazebo
  - There is a sensor for contact. It's a bit tricky to use
    - Needs to be inside a `gazebo` element, with a `reference` pointing to the link that is the bumper
    - The name for the `collision` element needs to be found after translation from xacro to urdf to sdf
      `rosrun xacro xacro --inorder -o model.urdf model.urdf.xacro` and then `gz sdf -p scuttle.urdf > scuttle.sdf`
      Then in the SDF file you'll see some severely mangled IDs. Pick the right ID and put that in the contact section
      (see: <https://answers.gazebosim.org/question/21992/what-collision-name-is-supposed-to-be-passed-to-contact-sensor/>)
    - The contact sensor in gazebo bounces, i.e. it will contact but occassionally lose that contact. This could be
      because of fake sensor bounce or ??????
  - Need a ROS node to interpret the messages coming from the bumpers

```
    <gazebo reference="front_bumper_plate_left_link">
        <sensor name="front_bumper_left" type="contact">
            <selfCollide>true</selfCollide>
            <alwaysOn>true</alwaysOn>
            <updateRate>15.0</updateRate>
            <material>Gazebo/WhiteGlow</material>
            <contact>
                <collision>base_link_fixed_joint_lump__front_bumper_plate_left_cl_collision_3</collision>
                <topic>bumper_contact</topic>
            </contact>
            <plugin name="gazebo_ros_bumper_controller_front_left" filename="libgazebo_ros_bumper.so">
                <bumperTopicName>scuttle_bumper</bumperTopicName>
                <frameName>front_bumper_plate_left_link</frameName>
            </plugin>
        </sensor>
    </gazebo>
```

- Physical bumper
  - Use ROSSerial to send bumper messages
  - Use the same node as in virtual to respond to bumper messages

- Drawbacks of this model is that you have message transitions (i.e. something sends messages and you
  have to process multiple messages). Not quite as fast
- Benefit. You can test it virtually. Can handle as many bumpers as you want

- Need a control node that blocks messages to `move_base` and `cmd_vel` messages so that we can
  stop the movement when we need


- Pictures of final product

- Picture of bread board
