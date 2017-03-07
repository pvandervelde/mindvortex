Title: Blog publishing with AppVeyor
Tags:
  - Hyper-V
  - Windows2016
---

* Updating my Hyper-V server from Windows 2012R2 to Windows2016
* Have an AD running in a VM, on the Hyper-V machine, so the upgrade is going to be interesting
* VM data is stored on a separate drive (so not on the OS drive)
* Would like to go for the pure Hyper-V installation but decided that would be too tricky with the AD VM also
  being on the Hyper-V machine
* Would also like to go for the Core installation but GUI is easier so going to use the GUI installation

Approach:

* Make backups of everything and be ready to rebuild the AD, i.e. this is a weekend job
* Create a bootable USB with the Windows2016 installer
* Attach a keyboard / mouse / monitor to the server
* Keep a machine available with an internet connection in case we need google (and we will)
* Insert the USB drive and reboot
* Enter BIOS and allow start-up from the USB drive
* Start windows installation, flatten the OS drive, no upgrades, remove all partitions and start from scratch
  (go hard or go home)
* After windows install, restore the VMs. this can be done by importing(?) the VMs from their config files.
  In my case this worked just fine
* Now we need to attach the Hyper-V machine to the domain (so that we can easily remote log in).
  Attaching to the domain is easy. The harder part is that the network connection will be set to public
  instead of domain, because when the Hyper-V machine comes up it doesn't have connection to the AD yet
  (because that is a VM running on the Hyper-V machine). So need to wait for the AD machine to start
  up and then re-evaluate the status of the network connection.
  So a scheduled task will do for that.

Over all easier than I thought, but there were still some tricks to pull.

And yes it would be better if the AD was spread over multiple machines but unfortunately I'm funding the hardware
myself and I currently can't justify having multiple servers in the house. So we'll have to do with hacks.
