Title: Updating my Hyper-V server to Windows 2016
Tags:
  - Hyper-V
  - Windows2016
---

One of the computers I have in my home is a Hyper-V server which I use to experiment with all things
virtual machines, e.g. [infrastructure-as-code](https://www.thoughtworks.com/insights/blog/infrastructure-code-reason-smile).
This server was until recently running Windows 2012R2 with the associated version of Hyper-V. With
the release of Windows 2016 a new version of Hyper-V was available which had some interesting
features, like [nested virtualization](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/nested-virtualization)
which allows running VMs on VMs and running Hyper-V containers. All in all enough interesting features
to warrant upgrading my server.

There are however some issues to deal with. The first one being, which version of Windows 2016 are
we going to install? The ideal version to install would be the [bare metal Hyper-V](https://technet.microsoft.com/en-us/hyper-v-server-docs/hyper-v-server-2016?f=255&MSPPError=-2147217396)
option with [Windows 2016 server Core](https://technet.microsoft.com/en-us/windows-server-docs/get-started/windows-server-2016)
being the second best option. The problem with these version is that it might be harder to
configure the network and attach the machine to the active directory. I currently don't have enough
experience managing Windows through (remote) powershell in order to be able to resolve those kinds
of issues without a large amount of help from Google or Bing. The goal for this exercise is to get
the machine updated so that we can use it, not to get the most lean version of Windows installed, so
I opted to go for the full GUI version of Windows 2016.

To make things more interesting my Active Directory server is a VM running on the Hyper-V server.
And yes I know there should be at least two Active Directory servers on different physical machines
but until I have lots of money and can afford to have multiple servers in my house I will work
with having a single AD server.

The approach I followed to upgrade the operating system on my server to Windows 2016 was as follows.

- Make backups of everything and be ready to spend some time restoring the AD server, i.e. this is
  probably better done as a weekend job.
- Create a [bootable USB](https://www.microsoft.com/en-us/download/windows-usb-dvd-download-tool)
  with the Windows2016 installer.
- Attach a keyboard, mouse and monitor to the server so that we can log in to the server directly.
  Installing Windows remotely is not possible with my local configuration.
- Insert the USB drive, reboot the server and make sure it boots from the USB key
- After the Windows installation starts make sure to remove the existing partitions on the original
  OS drive. While the OS could be upgraded that also leaves a lot of unused files around. Unfortunately
  in that case it will be hard to determine if these files can be deleted or not. By doing a clean
  install we can be sure that there will not be any left-overs from the upgrade.


Once the new operating system is installed the next step is to restore the VMs. Because all the
VM information was stored on physically different disks than the OS disk all the virtual hard drives
and VM configuration files still exist. In this case it is easy to import the old virtual machines
via the Hyper-V manager.

Once all the VMs were up and running again the last step was to attach the Hyper-V machine to the
domain so that it is easy to use the remote desktop capabilities. Now attaching the machine to
the domain is easy, the problem occurs when you have to restart the Hyper-V machine because after
the reboot the network connection will be set to the public profile instead of the domain profile
which means remote desktop and friends are all blocked. This is all caused by the fact that when the
Hyper-V machine boots up it doesn't have connection to the AD server, because that is a VM running
on the Hyper-V machine, and thus the network profile is set to be public for security purposes.

In order to fix this we need to either force the [Network Location Awareness service](https://newsignature.com/articles/network-location-awareness-service-can-ruin-day-fix/) to run
after the AD server has started, or we need to restart the service after a short period. In my case
setting the service start in delayed mode didn't really work so I created a scheduled task which
restarted the service by calling the following command line

    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noprofile -nologo -command "restart-service nlasvc -force"

Over all the upgrade was easier than I thought and there were only minor set backs. Some of the lessons
that were learned are:

- Ideally for jobs like this you would have an extra keyboard, mouse and monitor around, that way you
  can still use the normal PC for googling issues that you come across.
- Importing old VMs in Hyper-V is easy as long as you make sure that you know where all the files
  are.
- Ideally you would have multiple AD servers, running of different physical machines. Then again
  ideally I'd also have lots of money to pay for all these physical machines ;)
