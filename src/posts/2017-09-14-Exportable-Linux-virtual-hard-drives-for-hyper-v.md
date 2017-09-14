Title: Exportable Linux virtual hard-drives for Hyper-V
Tags:
  - Hyper-V
  - Ubuntu
  - Preseed
  - Unattend
---

- Automatically creating a VHD with a Linux install. Goal is to be able to copy the VHD and use it as a base HDD for
  new VMs
- Problem: https://blogs.msdn.microsoft.com/virtual_pc_guy/2015/02/11/copying-the-vhd-of-a-generation-2-linux-vmand-not-booting-afterwards/
  When using a Gen 2 VM (which has UEFI) you can't use the disk by itself
- So install everything on the drive


The preseed file is where all the magic is. Unfortunately the documentation for the different options is
hard to find. In the end I had to use a lot of googling and finding bits and pieces in different forums
and on different blogs.

Example preseeds:

* The official one from Ubuntu: https://help.ubuntu.com/lts/installation-guide/example-preseed.txt (see
  also the [appendix](https://help.ubuntu.com/lts/installation-guide/armhf/apb.html) in the installation
  guide which describes the installation automation via preseeding)
* https://cat.pdx.edu/~nibz/preseed/example-preseed.txt


Of much help

* https://blog.jhnr.ch/2017/02/23/resolving-no-x64-based-uefi-boot-loader-was-found-when-starting-ubuntu-virtual-machine/
  helped me figure out that to solve the final problem you have to force installation of an UEFI shim. Ubuntu apparently
  doesn't do that by default

STuff

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

    # Disable network configuration entirely. This is useful for cdrom
    # installations on non-networked devices where the network questions,
    # warning and long timeouts are a nuisance.
    #d-i netcfg/enable boolean false

    # netcfg will choose an interface that has link if possible. This makes it
    # skip displaying a list if there is more than one interface.
    d-i netcfg/choose_interface select auto

    # To pick a particular interface instead:
    #d-i netcfg/choose_interface select eth1

    # To set a different link detection timeout (default is 3 seconds).
    # Values are interpreted as seconds.
    #d-i netcfg/link_wait_timeout string 10

    # If you have a slow dhcp server and the installer times out waiting for
    # it, this might be useful.
    #d-i netcfg/dhcp_timeout string 60
    #d-i netcfg/dhcpv6_timeout string 60

    # If you prefer to configure the network manually, uncomment this line and
    # the static network configuration below.
    #d-i netcfg/disable_autoconfig boolean true

    # If you want the preconfiguration file to work on systems both with and
    # without a dhcp server, uncomment these lines and the static network
    # configuration below.
    d-i netcfg/dhcp_failed note ignore
    d-i netcfg/dhcp_options select Configure network manually

    # Static network configuration.
    #
    # IPv4 example
    d-i netcfg/get_ipaddress string ${NetworkConfigurationIpAddress}
    d-i netcfg/get_netmask string 255.255.255.0
    d-i netcfg/get_gateway string ${NetworkConfigurationGatewayIpAddress}
    d-i netcfg/get_nameservers string ${NetworkConfigurationDnsIpAddress}
    d-i netcfg/confirm_static boolean true

    #
    # IPv6 example
    #d-i netcfg/get_ipaddress string fc00::2
    #d-i netcfg/get_netmask string ffff:ffff:ffff:ffff::
    #d-i netcfg/get_gateway string fc00::1
    #d-i netcfg/get_nameservers string fc00::1
    #d-i netcfg/confirm_static boolean true

    # Any hostname and domain names assigned from dhcp take precedence over
    # values set here. However, setting the values still prevents the questions
    # from being shown, even if values come from dhcp.
    d-i netcfg/get_hostname string unassigned-hostname
    d-i netcfg/get_domain string unassigned-domain

    # If you want to force a hostname, regardless of what either the DHCP
    # server returns or what the reverse DNS entry for the IP is, uncomment
    # and adjust the following line.
    #d-i netcfg/hostname string somehost

    # Disable that annoying WEP key dialog.
    d-i netcfg/wireless_wep string
    # The wacky dhcp hostname that some ISPs use as a password of sorts.
    #d-i netcfg/dhcp_hostname string radish

    # If non-free firmware is needed for the network or other hardware, you can
    # configure the installer to always try to load it, without prompting. Or
    # change to false to disable asking.
    #d-i hw-detect/load_firmware boolean true


    #
    # *** Network console ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-network-console
    #



    #
    # *** Mirror setup ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-mirror
    #



    #
    # *** Account setup ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-account
    #

    # Skip creation of a root account (normal user account will be able to
    # use sudo). The default is false; preseed this to true if you want to set
    # a root password.
    #d-i passwd/root-login boolean false
    # Alternatively, to skip creation of a normal user account.
    #d-i passwd/make-user boolean false

    # Root password, either in clear text
    #d-i passwd/root-password password r00tme
    #d-i passwd/root-password-again password r00tme
    # or encrypted using a crypt(3)  hash.
    #d-i passwd/root-password-crypted password [crypt(3) hash]

    # To create a normal user account.
    d-i passwd/user-fullname string ${LocalAdministratorName}
    d-i passwd/username string ${LocalAdministratorName}

    # Normal user's password, either in clear text
    d-i passwd/user-password password ${LocalAdministratorPassword}
    d-i passwd/user-password-again password ${LocalAdministratorPassword}
    # or encrypted using a crypt(3) hash.
    #d-i passwd/user-password-crypted password [crypt(3) hash]
    # Create the first user with the specified UID instead of the default.
    #d-i passwd/user-uid string 1010

    # The installer will warn about weak passwords. If you are sure you know
    # what you're doing and want to override it, uncomment this.
    d-i user-setup/encrypt-home boolean false
    d-i user-setup/allow-password-weak boolean true

    # The user account will be added to some standard initial groups. To
    # override that, use this.
    #d-i passwd/user-default-groups string audio cdrom video

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

    ## Partitioning example
    # If the system has free space you can choose to only partition that space.
    # This is only honoured if partman-auto/method (below) is not set.
    # Alternatives: custom, some_device, some_device_crypto, some_device_lvm.
    #d-i partman-auto/init_automatically_partition select biggest_free

    # Alternatively, you may specify a disk to partition. If the system has only
    # one disk the installer will default to using that, but otherwise the device
    # name must be given in traditional, non-devfs format (so e.g. /dev/hda or
    # /dev/sda, and not e.g. /dev/discs/disc0/disc).
    # For example, to use the first SCSI/SATA hard disk:
    #d-i partman-auto/disk string /dev/sda

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
    #d-i partman-auto-lvm/guided_size string 10GB
    #d-i partman-auto-lvm/guided_size string 50%

    d-i partman-auto-lvm/new_vg_name string system

    # You can choose one of the three predefined partitioning recipes:
    # - atomic: all files in one partition
    # - home:   separate /home partition
    # - multi:  separate /home, /usr, /var, and /tmp partitions
    d-i partman-auto/choose_recipe select grub-efi-boot-root

    # Or provide a recipe of your own...
    # If you have a way to get a recipe file into the d-i environment, you can
    # just point at it.
    #d-i partman-auto/expert_recipe_file string /hd-media/recipe

    d-i partman-partitioning/confirm_write_new_label boolean true

    # If you just want to change the default filesystem from ext3 to something
    # else, you can do that without providing a full recipe.
    d-i partman/default_filesystem string ext4

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


    ## Controlling how partitions are mounted
    # The default is to mount by UUID, but you can also choose "traditional" to
    # use traditional device names, or "label" to try filesystem labels before
    # falling back to UUIDs.
    #d-i partman/mount_style select uuid

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
    # *** base system installation ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-apt
    #

    d-i base-installer/kernel/override-image string linux-server


    #
    # *** Apt setup ***
    #
    # Originally from: https://help.ubuntu.com/lts/installation-guide/armhf/apbs04.html#preseed-apt
    #


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

    # Grub is the default boot loader (for x86). If you want lilo installed
    # instead, uncomment this:
    #d-i grub-installer/skip boolean true
    # To also skip installing lilo, and install no bootloader, uncomment this
    # too:
    #d-i lilo-installer/skip boolean true


    # This is fairly safe to set, it makes grub install automatically to the MBR
    # if no other operating system is detected on the machine.
    d-i grub-installer/only_debian boolean true

    # This one makes grub-installer install to the MBR if it also finds some other
    # OS, which is less safe as it might not be able to boot that other OS.
    d-i grub-installer/with_other_os boolean true

    # Due notably to potential USB sticks, the location of the MBR can not be
    # determined safely in general, so this needs to be specified:
    #d-i grub-installer/bootdev  string /dev/sda
    # To install to the first device (assuming it is not a USB stick):
    #d-i grub-installer/bootdev  string default

    # Alternatively, if you want to install to a location other than the mbr,
    # uncomment and edit these lines:
    #d-i grub-installer/only_debian boolean false
    #d-i grub-installer/with_other_os boolean false
    d-i grub-installer/bootdev string /dev/sda
    d-i grub-installer/force-efi-extra-removable boolean true
    d-i grub-installer/no-nvram boolean true

    # To install grub to multiple disks:
    #d-i grub-installer/bootdev  string (hd0,1) (hd1,1) (hd2,1)

    # Optional password for grub, either in clear text
    #d-i grub-installer/password password r00tme
    #d-i grub-installer/password-again password r00tme
    # or encrypted using an MD5 hash, see grub-md5-crypt(8).
    #d-i grub-installer/password-crypted password [MD5 hash]

    # Use the following option to add additional boot parameters for the
    # installed system (if supported by the bootloader installer).
    # Note: options passed to the installer will be added automatically.
    #d-i debian-installer/add-kernel-opts string nousb

    # grub-install –target=x86_64-efi –efi-directory=/boot/efi –no-nvram –removable

    #
    # *** Preseed other packages ***
    #

    d-i debconf debconf/frontend select Noninteractive
    d-i finish-install/reboot_in_progress note

    choose-mirror-bin mirror/http/proxy string
