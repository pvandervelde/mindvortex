Title: Sherlock configuration - Virtual machines
Tags:
  - Sherlock
---
After [setting up the host machine](/posts/Setting-up-Sherlock-serverside.html) the next step in
the [configuration](/posts/Regression-testing-with-Sherlock.html) of Sherlock is to set up one or
more virtual machines. Each virtual machine will have the following applications installed:

- The update service which handles the installation of the latest available Sherlock binaries.
- The executor service which handles the communication with the master controller, handles the
  download and upload of test files and test reports and controls the test execution.
- The application which executes the test steps. This has been separated from the service so that:
    * It is possible to run the application on the desktop while the executor service is running as
      a Windows service.
    * Any fatal errors in the test application don't affect the service, thereby maintaining
      communication with the master controller, and thus allowing error reports to be send.
    * It is possible to run multiple applications under different accounts (planned in future releases).

The configuration process for a virtual machine consists of the following steps:

- Create a new virtual machine and install the operating system
- Configure the operating system on the virtual machine
- Install and configure the Sherlock applications on the virtual machine
- Store information about the virtual machine in the host database


### Preparing the virtual machine

The first step is to create a [new virtual machine](http://technet.microsoft.com/en-us/library/cc772480.aspx)
and install the operating system. This should be straight forward but there a few things to look out
for:

- The operating system must (currently) support [.NET 4.5](http://en.wikipedia.org/wiki/.NET_Framework_version_history#.NET_Framework_4.5)
  because that is what Sherlock is needs to run on.
- The network for the virtual machine must be set up so that it can at the very least see the host
  machine and the other virtual machines stored on the same host machine.
    * **Note:** Windows networks can [deny access](http://www.petri.co.il/working-with-domain-member-virtual-machines-and-snapshots.htm)
    to the test virtual machines after being used for a while (usually 30 days) due to the fact that
    the test machine is reset after each test, thereby not allowing it to handle the renewal of
    network identification keys correctly.


### Preparing the operating system

After the creation of the virtual machine and the installation of the operating system it is necessary
to configure the operating system. Some of the changes are necessary for Sherlock to function while
others are necessary only from a test perspective.

Lets first start with the changes required for Sherlock to function.

- If .NET 4.5 is not already installed, then install it. Without it Sherlock won't run at all.
- Create a new user that will be used to execute the tests. This user needs to be an administrator so
  that the execution of an MSI install can succeed without the need for elevation (which is
  [a bit tricky](http://stackoverflow.com/questions/5098121/how-can-i-get-elevated-permissions-uac-via-impersonation-under-a-non-interacti)
  from an application). The user can be either a machine local administrator or a domain user  which
  is granted administration rights on the machine.
    * Note that there might a difference between a domain user with administrative rights on the
      computer and a local administrator. If you turn UAC off then in general a local administrator
      is running all applications elevated while the applications started by the domain user run with
      no elevation only to be silently elevated if requested to do so. Unfortunately this means that
      the domain user will not be able to run a silent install from a command line unless that command
      line is explicitly elevated (which is not possible from an application).
- Disable User Access Control (UAC) so that Sherlock can execute MSI installations. **Note:** In some
  cases corporate network controls and/or group policies override local settings. In those cases talk
  to the local IT people regarding UAC. Also note that on Windows 8 it is not possible to turn off
  the UAC by moving the 'UAC slider' all the way down. This is because Metro applications require some
  form of UAC to exist in order for them to work.

Finally before installing Sherlock a few tweaks should be made to the operating system configuration
so that the automated tests can proceed. Note that for all the following changes there may be group
policies in place put there by your local IT service. It may be necessary to talk to the IT people
about the settings you want to change and the [reason](http://www.brianbondy.com/blog/id/100/) you
need to change those settings.

- **Interactive user:** If you need to run interactive tests, e.g. UI tests, then you need to make
  sure a user is logged in. Use [Autologon](http://technet.microsoft.com/en-us/sysinternals/bb963905.aspx)
  to automatically log your user in when the computer starts while still maintaining password security.
- **Windows 8 switch to desktop:** If you are on Windows 8 you need to make sure that the desktop is
  [available](http://www.7tutorials.com/how-boot-desktop-windows-8-skip-start-screen) for interactive
  applications to execute on.
- **Screen saver:** In order to prevent any interactive tests from failing due to a
  [screensaver](http://windows.microsoft.com/en-nz/windows-vista/turn-your-screen-saver-on-or-off) or
  the [automatic locking of the desktop](http://answers.microsoft.com/en-us/windows/forum/windows_7-security/disable-automatic-lock-with-windows-7/daef8f0a-810f-46e8-9420-3c32c4bd6479)
  both those features need to be turned off.
- **Windows error reporting:** Any tests that run on the desktop may hang eternally if the application
  under tests fails and displays the Windows Error Reporting (WER) dialog. In order to prevent this
  from happening [WER should be disabled](http://4sysops.com/archives/how-to-disable-windows-error-reporting/).
  The most efficient way of doing this is to use the group policy controls to disable the following elements:
    * In `Computer Configuration\Administrative Templates\System\Internet Communication Management\Internet Communication settings`
      enable the setting: `Turn off Windows Error Reporting`.
    * In `Computer Configuration\Administrative Templates\Windows Components\Windows Error Reporting`
      enable the settings `Disable Windows error reporting` and
      `Prevent display of the user interface for critical errors`, and disable the setting
      `Display error notification`.
- **Automatic updates:** Automatic updates can be disabled because they will never be deployed due
  to the fact that the machine is reset after each test.


### Configuring Sherlock

Once the operating system is configured [Sherlock](/projects/sherlock.html) can be installed and configured.

- Unzip the **service.zip** package into the `c:\sherlock` directory.
- Copy the XML file containing the public key used to sign the manifests to the virtual machine and
  place it in the `c:\sherlock` directory.
- Open the configuration file (`Sherlock.Service.exe.config`) and update the following settings:
    * **ApplicationName:** The name of the application for which updates should be tracked, in this
      case that is: `Sherlock.Service.Executor.exe`.
    * **UpdateManifestUri:** The URL of the manifest file, in this case: `http:\\myhostmachine\appupdate\executorservice.manifest`
    * **ManifestPublicKeyFile:** The path to the XML file containing the public key section of the
      manifest signing key, e.g. `C:\sherlock\manifestsigningkey.public.xml`
- Set the update service to start automatically when the computer starts. This can be done as an
  actual service (in case no interactive tests will be executed) or by automatically starting the
  application when the user logs on to windows (in case interactive tests need to be executed).
- The last step is to let the executor controller through the firewall. For this create an inbound
  rule that allows `c:\ProgramData\Sherlock\Sherlock.Service.Executor\{VERSION}\Sherlock.Service.Executor.exe`
  to connect to all types of protocols. Normally only Domain and private networks should be sufficient.


### Testing

Once the operating system and Sherlock have been configured it is sensible to test the configurations
to make sure it all works. In order to do this take the following steps:

- Restart the virtual machine. Once the machine starts up it should (depending on your configuration)
    * Automatically log on the test user
    * On windows 8 switch to the desktop
    * Start the Sherlock update service. The service should download the latest version of the executor
      controller and start it. You can verify this by looking at the logs which can be found in
      `c:\programdata\sherlock\sherlock.service\{VERSION}\logs` and `c:\programdata\sherlock\sherlock.service.executor\{VERSION}\logs`
      for the update service and the executor controller respectively.
- After both applications have started stop them both by stopping the update service (`Sherlock.Service`).
- Once the applications have been stopped remove the data from the directory `c:\ProgramData\Sherlock`.
- Shut down the machine.
- Take a [snapshot](http://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/16/managing-snapshots-with-hyper-v.aspx)
  of the current state of the virtual machine and give it a sensible name.


### Host configuration

Finally the last step in the configuration of a new test environment is to register the environment
with Sherlock through the management website.
