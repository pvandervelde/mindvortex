Title: Setting up a home network with Ubiquiti
Tags:
  - Hardware
  - Home network
  - Ubiquiti
---

A little while back we finally got fibre in our street. After spending many years on ADSL (we don't
talk about the time of dial-up ...) it was finally time for some decent network speeds at home. As
the fibre was being installed in my house it was also time to evaluate the networking gear I was
using. Until now I had always used the modem / router provided by the ISP with an additional cheap
switch. The gear always worked fine, but didn't provide configuration options other than the ones that
describe the connection to the ISP. As I was starting to use my [Hyper-V server](./posts/Updating-Hyper-v-server-to-Windows2016)
a lot more and was starting to run multiple VM's it would be nice to get some better control over
the network. Additionally based on one of [Troy Hunt's](https://www.troyhunt.com/no-you-cant-join-my-wifi-network/)
blog posts I would also like to set up a separate guest network.


### The selection

The prolific Troy Hunt has written about his [network](https://www.troyhunt.com/ubiquiti-all-the-things-how-i-finally-fixed-my-dodgy-wifi/)
setup so I used that as my starting point for finding some new network gear. Fortunately (or unfortunately)
I don't have as much area to cover as Troy does so I didn't need nearly as much hardware. The parts
I got are:

- [Unifi security gateway](https://www.ubnt.com/unifi-routing/usg/): The router which provides amongst
  other things a firewall, subnet capabilities and DHCP.
- [Unifi switch 8 (US-8-60W)](https://www.ubnt.com/unifi-switching/unifi-switch-8/): The managed switch
  which has 4 [PoE](https://en.wikipedia.org/wiki/Power_over_Ethernet) ports.
- [Unifi AP AC LITE](https://www.ubnt.com/unifi/unifi-ap-ac-lite/): The smallest indoor access point
  available from Ubiquiti. Given that my apartment is relatively small I don't have to worry about
  covering a lot of area, and smaller access points are cheaper.
- [Unifi cloud key](https://www.ubnt.com/unifi/unifi-cloud-key/): The management device which runs
  the Unfi software for managing the network.

Except for the cloud key this is pretty much the minimal set of hardware required. The cloud key runs
the unifi software which is used to manage the network configuration. You can install the unifi
software on a PC but then you need an extra PC or VM running. While I have a Hyper-V server it was easier
just to pay for the cloud key and have a separate controller for the network. Note that the network
functions just fine without any configuration. However if you want to make changes the easiest way
to do so is through the unifi software, although you could do it by SSH-ing into each device.

Another thing to note is that the the 60W switch has 4 PoE ports of the 802.3af kind. Unfortunately
the access point requires 24V passive PoE. So either you have to:

- Power the access point of the converter that you get with the access point.
- Upgrade the access point to the [UAP-AC-PRO](https://www.ubnt.com/unifi/unifi-ap-ac-pro/)
- Upgrade the switch to the [US-8-150W](https://www.ubnt.com/unifi-switching/unifi-switch-8-150w/)
  switch which has both 802.3af PoE and 24V passive PoE.

As much as I would like to power the access point of the switch I still opted for the first option,
the additional investment wasn't quite worth having one less cable around.


### Configuration

The actual configuration was pretty easy, plug in all the parts and things start working, at least
for the internal network. Once this is done you can configure the network through the unifi software.
To do so the first thing to do is to to find the cloud key. There's a useful plugin for
[chrome](https://chrome.google.com/webstore/detail/ubiquiti-device-discovery/hmpigflbjeapnknladcfphgkemopofig?utm_source=chrome-app-launcher-info-dialog)
that allows you to find any Ubiquiti devices on your local network, otherwise you can try to guess
the IP address of the cloud key. If you only have 4 devices like I do that shouldn't take very long.
The gateway by default assumes you are using the `192.168.1.0/24` subnet and the gateway is always
the first one.

Once you are logged on to the unifi software it makes sense to give the cloud key a fixed IP address
I gave mine the 192.168.1.2 IP address as I am using the `192.168.1.1/24` subnet for all my networking
gear. And yes I know I don't have enough networking devices for them to warrant being on their own
subnet but it makes things a little easier and it allows me to learn about [subnetting](https://en.wikipedia.org/wiki/Subnetwork)
and [vlans](https://en.wikipedia.org/wiki/Virtual_LAN).


### Subnetting adventures

As mentioned in the introduction one of the changes I wanted to make was to create a separate guest
network. By default a vlan only guest network is created, however I wanted to move the guests onto
their own subnet so I created a new network with the `192.168.5.1/24` subnet. I also set the vlan
specifier to `1685`. And finally I marked this network as a guest network so that the controller
applies the guest firewall rules.

Then I created a wireless guest network with the same vlan. What confused me initially is that there
is no relation between the wireless network and the subnet other than the vlan tag. Somehow having the
same vlan tag is enough to direct the clients onto the the correct subnet.

The last step of the configuration of the guest network is to configure the switch. Because the
access point has three different subnets going to it, the managment subnet for the access point itself,
the guest wifi and the internal wifi, you need to create a custom 'network' on the switch which carries
all three networks, making sure that the untagged network is the one on which you want the access
point to get an IP address.

Another item I found was that for some purposes the standard IP lease of 24 hours is a bit long. One
of the things I'm currently working on is building VM images of different services for use in a test
build environment. While doing that I'm creating [base boxes](https://github.com/Calvinverse) for
Windows and Linux which involves spinning up a VM, installing the OS, configuring it and capturing
the image. While working on the code to automate this process I spin up and shut down VMs quite a lot.
If you're using the gateway as the DHCP server and use the standard IP lease time then you run through
IP addresses quite quickly. So I created have a separate IP subnet for those VMs where the IP lease
time is 2 hours (which is more than long enough to create a VM and capture a base image).


### In the end

In conclusion it's a good set of hardware and software and as a bonus, there are updates which apply
without problems. There is something reassuring in the fact that the manufacturer actually cares enough
about their product that they want to keep it running, unlike much of the consumer gear.

The unifi software provides a lot of useful and interesting capabilities and it's obviously aimed
at the business / educational environment. There are a lot of of features that I don't need, but they
are fun to play with
