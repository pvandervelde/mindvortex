Title: Exportable Linux virtual hard-drives for Hyper-V
Tags:
  - Hyper-V
  - Preseed
  - Ubuntu
  - Unattend
---

As part of learning more about infrastructure creation, testing and deployment one of the projects
I'm working on is creating a set of virtual machine images for [Windows](https://github.com/Calvinverse/base.windows)
and [Linux](https://github.com/Calvinverse/base.linux) which can be used as a base for more complex
virtual machine based resources, e.g. [a consul host](https://github.com/Calvinverse/resource.hashi.server)
or [a docker host](https://github.com/Calvinverse/resource.container.host.linux).

The main virtualization technology I use is Hyper-V on both Windows 10 and Windows 2016 which allows
creating [Generation 2](https://technet.microsoft.com/en-us/library/dn282285(v=ws.11).aspx) virtual machines.
Some of the
[benefits of a generation 2](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/plan/should-i-create-a-generation-1-or-2-virtual-machine-in-hyper-v)
virtual machine are:

- Boot volume up to 64 Tb
- Use of [UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) for the boot process
- Faster boot

The initial version of the base resources allowed creating a virtual machine with
[Packer](https://packer.io) and exporting that virtual machine to be used as a base. However ideally
all one would need is the virtual hard-drive. The virtual machine configuration can easily be
created for each individual resource and the configuration is usually specific to the original
host by virtue of it containing the absolute path of the virtual hard drive, the name of the network
interfaces etc..

When building Ubuntu virtual disk images one of the issues with using a Generation 2 virtual machine is that
it uses UEFI for the boot process. It turns out that the Ubuntu install process stores the UEFI files
in the [virtual machine configuration file](https://blogs.msdn.microsoft.com/virtual_pc_guy/2015/02/11/copying-the-vhd-of-a-generation-2-linux-vmand-not-booting-afterwards/).
This means that when one creates a new virtual machine from the base virtual disk image it runs into
a problem when booting because the boot files are not present in the new machine. The result is this

<p><img align="center" alt="Hyper-V error message due to missing UEFI sector" src="/assets/images/infrastructure/hyperv-gen2-ubuntu-missing-uefi-sector-result.png" /></p>

The solution to this issue obviously is to force the Ubuntu installer to write the UEFI files to the
virtual hard disk which can be achieved by adding the correct configuration values to the
[preseed file](https://help.ubuntu.com/lts/installation-guide/armhf/apb.html). Unfortunately the
documentation for the different options in the preseed files is hard to find. In the end a combination
of the [ubuntu sample preseed](https://help.ubuntu.com/lts/installation-guide/example-preseed.txt) file,
bug reports, old forum messages and a few blog
[posts](https://blog.jhnr.ch/2017/02/23/resolving-no-x64-based-uefi-boot-loader-was-found-when-starting-ubuntu-virtual-machine/)
allowed me to determine that to make the Ubuntu installer place the UEFI files in the correct location
two parts of the preseed file needed to be changed from the default Ubuntu one. The first
part is the partitioning section which requires that at least an `EFI` partition and (most likely)
a `boot` partition are defined. This almost requires that a custom recipe is defined. The one
I currently use looks as follows:

    # Or provide a recipe of your own...
    # If not, you can put an entire recipe into the preconfiguration file in one
    # (logical) line. This example creates a small /boot partition, suitable
    # swap, and uses the rest of the space for the root partition:
    d-i partman-auto/expert_recipe string       \
        grub-efi-boot-root ::                   \
            1 1 1 free                          \
                $bios_boot{ }                   \
                method{ biosgrub }              \
            .                                   \
            256 256 256 fat32                   \
                $primary{ }                     \
                method{ efi }                   \
                format{ }                       \
            .                                   \
            512 512 512 ext4                    \
                $primary{ }                     \
                $bootable{ }                    \
                method{ format }                \
                format{ }                       \
                use_filesystem{ }               \
                filesystem{ ext4 }              \
                mountpoint{ /boot }             \
            .                                   \
            4096 4096 4096 linux-swap           \
                $lvmok{ }                       \
                method{ swap }                  \
                format{ }                       \
            .                                   \
            10000 20000 -1 ext4                 \
                $lvmok{ }                       \
                method{ format }                \
                format{ }                       \
                use_filesystem{ }               \
                filesystem{ ext4 }              \
                mountpoint{ / }                 \
            .

Note that syntax for the partioner section is very particular. Note especially the  dots (`.`) at
the end of each section. If the syntax isn't completely correct nothing will work but no sensible
error messages will be provided.
Additionally the Ubuntu install complained when there was no `swap` section so I added one. This
shouldn't be necessary to get the UEFI files in the correct location but it is apparently necessary
to get Ubuntu to install in the first place.

The second part of the preseed file that should be changed is the `grub-installer` section. There
the following line should be added

    d-i grub-installer/force-efi-extra-removable boolean true

This line indicates that grub should force install the UEFI files, thus overriding the normal state
of not installing the UEFI boot files.

This means that the complete preseed file looks as follows

    # preseed configuration file for Ubuntu.
    # Based on: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html

    #
    # *** Localization ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-l10n
    #

    # Preseeding only locale sets language, country and locale.
    d-i debian-installer/locale string en_US.utf8

    # Keyboard selection.
    # Disable automatic (interactive) keymap detection.
    d-i console-setup/ask_detect boolean false
    d-i console-setup/layout string us

    d-i kbd-chooser/method select American English

    #
    # *** Network configuration ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-network
    #

    # netcfg will choose an interface that has link if possible. This makes it
    # skip displaying a list if there is more than one interface.
    d-i netcfg/choose_interface select auto

    # If you want the preconfiguration file to work on systems both with and
    # without a dhcp server, uncomment these lines and the static network
    # configuration below.
    d-i netcfg/dhcp_failed note ignore
    d-i netcfg/dhcp_options select Configure network manually

    # Any hostname and domain names assigned from dhcp take precedence over
    # values set here. However, setting the values still prevents the questions
    # from being shown, even if values come from dhcp.
    d-i netcfg/get_hostname string unassigned-hostname
    d-i netcfg/get_domain string unassigned-domain

    # Disable that annoying WEP key dialog.
    d-i netcfg/wireless_wep string


    #
    # *** Account setup ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-account
    #

    # To create a normal user account.
    d-i passwd/user-fullname string localadmin
    d-i passwd/username string localadmin

    # Normal user's password, either in clear text
    d-i passwd/user-password password reallygoodpassword
    d-i passwd/user-password-again password reallygoodpassword

    # The installer will warn about weak passwords. If you are sure you know
    # what you're doing and want to override it, uncomment this.
    d-i user-setup/encrypt-home boolean false
    d-i user-setup/allow-password-weak boolean true

    # Set to true if you want to encrypt the first user's home directory.
    d-i user-setup/encrypt-home boolean false


    #
    # *** Clock and time zone setup ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-time
    #

    # Controls whether or not the hardware clock is set to UTC.
    d-i clock-setup/utc boolean true
    d-i clock-setup/utc-auto boolean true

    # You may set this to any valid setting for $TZ; see the contents of
    # /usr/share/zoneinfo/ for valid values.
    d-i time/zone string UTC


    #
    # *** Partitioning ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-partman
    #

    # This makes partman automatically partition without confirmation, provided
    # that you told it what to do using one of the methods below.
    d-i partman/choose_partition select finish
    d-i partman/confirm boolean true
    d-i partman/confirm_nooverwrite boolean true

    # In addition, you'll need to specify the method to use.
    # The presently available methods are:
    # - regular: use the usual partition types for your architecture
    # - lvm:     use LVM to partition the disk
    # - crypto:  use LVM within an encrypted partition
    d-i partman-auto/method string lvm
    d-i partman-auto/purge_lvm_from_device boolean true

    # If one of the disks that are going to be automatically partitioned
    # contains an old LVM configuration, the user will normally receive a
    # warning. This can be preseeded away...
    d-i partman-lvm/device_remove_lvm boolean true
    d-i partman-lvm/device_remove_lvm_span boolean true

    # And the same goes for the confirmation to write the lvm partitions.
    d-i partman-lvm/confirm boolean true
    d-i partman-lvm/confirm_nooverwrite boolean true

    # For LVM partitioning, you can select how much of the volume group to use
    # for logical volumes.
    d-i partman-auto-lvm/guided_size string max
    d-i partman-auto-lvm/new_vg_name string system

    # You can choose one of the three predefined partitioning recipes:
    # - atomic: all files in one partition
    # - home:   separate /home partition
    # - multi:  separate /home, /usr, /var, and /tmp partitions
    d-i partman-auto/choose_recipe select grub-efi-boot-root

    d-i partman-partitioning/confirm_write_new_label boolean true

    # If you just want to change the default filesystem from ext3 to something
    # else, you can do that without providing a full recipe.
    d-i partman/default_filesystem string ext4

    # Or provide a recipe of your own...
    # If not, you can put an entire recipe into the preconfiguration file in one
    # (logical) line. This example creates a small /boot partition, suitable
    # swap, and uses the rest of the space for the root partition:
    d-i partman-auto/expert_recipe string       \
        grub-efi-boot-root ::                   \
            1 1 1 free                          \
                $bios_boot{ }                   \
                method{ biosgrub }              \
            .                                   \
            256 256 256 fat32                   \
                $primary{ }                     \
                method{ efi }                   \
                format{ }                       \
            .                                   \
            512 512 512 ext4                    \
                $primary{ }                     \
                $bootable{ }                    \
                method{ format }                \
                format{ }                       \
                use_filesystem{ }               \
                filesystem{ ext4 }              \
                mountpoint{ /boot }             \
            .                                   \
            4096 4096 4096 linux-swap           \
                $lvmok{ }                       \
                method{ swap }                  \
                format{ }                       \
            .                                   \
            10000 20000 -1 ext4                 \
                $lvmok{ }                       \
                method{ format }                \
                format{ }                       \
                use_filesystem{ }               \
                filesystem{ ext4 }              \
                mountpoint{ / }                 \
            .

    d-i partman-partitioning/no_bootable_gpt_biosgrub boolean false
    d-i partman-partitioning/no_bootable_gpt_efi boolean false

    # enforce usage of GPT - a must have to use EFI!
    d-i partman-basicfilesystems/choose_label string gpt
    d-i partman-basicfilesystems/default_label string gpt
    d-i partman-partitioning/choose_label string gpt
    d-i partman-partitioning/default_label string gpt
    d-i partman/choose_label string gpt
    d-i partman/default_label string gpt

    # Keep that one set to true so we end up with a UEFI enabled
    # system. If set to false, /var/lib/partman/uefi_ignore will be touched
    d-i partman-efi/non_efi_system boolean true


    #
    # *** Package selection ***
    #
    # originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-pkgsel
    #

    tasksel tasksel/first multiselect standard, ubuntu-server

    # Minimum packages (see postinstall.sh). This includes the hyper-v tools
    d-i pkgsel/include string openssh-server ntp linux-tools-$(uname -r) linux-cloud-tools-$(uname -r) linux-cloud-tools-common

    # Upgrade packages after debootstrap? (none, safe-upgrade, full-upgrade)
    # (note: set to none for speed)
    d-i pkgsel/upgrade select none

    # Policy for applying updates. May be "none" (no automatic updates),
    # "unattended-upgrades" (install security updates automatically), or
    # "landscape" (manage system with Landscape).
    d-i pkgsel/update-policy select none

    # Language pack selection
    d-i pkgsel/install-language-support boolean false

    #
    # Boot loader installation
    #

    # This is fairly safe to set, it makes grub install automatically to the MBR
    # if no other operating system is detected on the machine.
    d-i grub-installer/only_debian boolean true

    # This one makes grub-installer install to the MBR if it also finds some other
    # OS, which is less safe as it might not be able to boot that other OS.
    d-i grub-installer/with_other_os boolean true

    # Alternatively, if you want to install to a location other than the mbr,
    # uncomment and edit these lines:
    d-i grub-installer/bootdev string /dev/sda
    d-i grub-installer/force-efi-extra-removable boolean true


    #
    # *** Preseed other packages ***
    #

    d-i debconf debconf/frontend select Noninteractive
    d-i finish-install/reboot_in_progress note

    choose-mirror-bin mirror/http/proxy string

The complete preseed file can also be found in the
[http preseed directory](https://github.com/ops-resource/ops-tools-baseimage/tree/master/src/linux/ubuntu/http)
of the [Ops-Tools-BaseImage](https://github.com/ops-resource/ops-tools-baseimage) project. This
project also publishes a [NuGet](https://www.nuget.org/packages/Ops.Tools.BaseImage.Linux/) package
which has all the configuration files and scripts that were used to create the Ubuntu base virtual
hard drive.
