Title: Setting up a home network with Ubiquiti
Tags:
  - Hardware
  - Home network
  - Ubiquiti
---

A little while back we finally got fibre in our street. After spending many years on ADSl (we don't
talk about the time of dial-up ...) it was finally time for some decent network speeds at home. As
the fibre was being installed in my house it was also time to evaluate the networking gear I was
using. Until then

- Until then only used standard consumer gear. That worked fine, but didn't allow much configuration. The last router
  I had allowed some configuration of IP distribution but still limited. As I was getting more hardware (the Hyper-V
  server) and was starting to run multiple VM's it was nice to get some better control over the network
- Would really like to have a separate guest network, because [Troy Hunt](https://www.troyhunt.com/no-you-cant-join-my-wifi-network/)
- Learning about vlans and subnetting at work so want to apply some of that at home too
- Do I need these capabilities ... well no, do I want them .. of course


Based on the approach taken by [Troy Hunt](https://www.troyhunt.com/ubiquiti-all-the-things-how-i-finally-fixed-my-dodgy-wifi/)
I decided that [Ubiquiti]()

- Got the following bits
  - [Unifi security gateway](https://www.ubnt.com/unifi-routing/usg/)
  - [Unifi switch 8 (US-8-60W)](https://www.ubnt.com/unifi-switching/unifi-switch-8/)
  - [Unifi AP AC LITE](https://www.ubnt.com/unifi/unifi-ap-ac-lite/)
  - [Unifi cloud key](https://www.ubnt.com/unifi/unifi-cloud-key/)
- Technically you don't need the cloud key, but you need some way to manage the hardware bits. You can install the
  unifi software on a PC or VM but then you need an extra PC or VM running. I have a Hyper-V server so I could put
  it on a VM there but it was easier just to pay for the cloud key and have a separate controller for the network.
  Note that the network functions just fine without any configuration. The default settings work just fine. However
  if you want to make changes the easiest way to do so is through the unifi software (although you could do it by
  SSH-ing into each device)
- One thing to note would be that the 60W switch has 4 PoE ports of the 802.3af kind. Unfortunately the access point
  requires 24V passive PoE. So either you have to:
  - Power the access point of the converter that you get with the access point. That's what I'm currently doing
  - Upgrade the access point to the [UAP-AC-PRO](https://www.ubnt.com/unifi/unifi-ap-ac-pro/)
  - Upgrade the switch to the [US-8-150W](https://www.ubnt.com/unifi-switching/unifi-switch-8-150w/) switch which
    does provide 24V passive PoE.

## Configuration

- The actual configuration was pretty easy, it's basically plug and play.
- Once everything is plugged in and has power (especially check that the AP has power, because trying to power it via a
  802 PoE doesn't work when it needs 24V passive). Then you can go configure the network
- To configure the network you first need to find the cloud key. There's a useful plugin for
  [chrome](https://chrome.google.com/webstore/detail/ubiquiti-device-discovery/hmpigflbjeapnknladcfphgkemopofig?utm_source=chrome-app-launcher-info-dialog)
  that allows you to find any Ubiquiti devices on your local network. I used this tool to find the cloud key
- Once you are logged on it makes sense to give the cloud key a fixed IP address (you don't have to but then it's going
  to be hard to find). I gave mine the 192.168.1.2 IP address (the security gateway has 192.168.1.1)
  - In fact now I have all my networking gear on the 192.168.1.1/24 subnet. Does it need a subnet all of its own, no
    but it's easy that way and it allowed me to play with the subnetting capabilities of the gear
-

- The hardest part was actually finding the correct length network cables so that there wasn't a giant mess of cables
  around. I mostly succeeded but there's still a bit of a mess. Fortunately the Hyper-V box blocks the view of the
  cables :)


## Interesting things

- Created a subnet for the guest network and then denied access to the guest network so that it can't interact with
  the rest of the IP subnets. In order to make this work you need to:
  - Create the guest subnet. In my case it's 192.168.5.1/24 with vlan 1685. Assign this to be a guest network. That allows
    the controller to apply different firewall rules
  - I created a wireless network with the same vlan. The wireless network and the subnet aren't related other than through
    the vlan. Make sure to set it to be a guest network
  - In the switch create a new custom 'network' which includes both the normal wifi and the guest wifi as tagged networks.
    In my case the untagged network is the management network so that the access point can get its IP address from the
    correct network.
  - Configure the port on the switch that has the access point to have the custom network as its network.
- My personal wireless network has a different ip range than the wired network just in case I have my wireless activated
  on my laptop while also having it plugged into the LAN (as per advice of the system administrator at work)
- One of the things I'm currently working on is building VM images of different services for use in a test build environment.
  While doing that I'm creating [base boxes]() for Windows and Linux which involves spinning up a VM, installing the
  OS, configuring it and capturing the image. During this process I spin up VMs quite a lot, and terminate them really
  quickly. If you're using the gateway as the DHCP server then you run through IP addresses quite quickly. And the
  standard IP lease time is 24 hours. So now I have a separate IP subnet for those VMs where the IP lease time is 2 hours
  (which is more than long enough to create a VM and capture a base image)

The unifi software provides a lot of useful (and interesting) capabilities and it's obviously aimed at the small business /
educational environment. Lots of capabilities that I don't really need, but fun to play with. Like:
- Deep packet inspection. Apparently I watch a lot of youtube
- The topology map which shows how the different devices connect (IMAGE HERE)

All in all it's a good set of hardware and as a bonus, there are updates which apply (until now) without problems. There
is something reassuring in the fact that the manufacturer actually cares enough about their product that they want to keep
it running, unlike much of the consumer gear.
