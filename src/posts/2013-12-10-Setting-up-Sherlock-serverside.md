Title: Sherlock configuration - Server side
Tags:
  - Sherlock
---

In this post I will explain how to configure the [Sherlock](/projects/sherlock.html) host services,
which handle test registration and selection and control of the test environments for a test. The
set-up follows the following steps:

- Preparing the host machine which includes installation of the OS and the required services.
- Installation of database.
- Installation of the web parts.
- Creation of the update files and the update manifests.
- Installation of the services.
- Configuration of the firewall.
- Verification of the configuration.


### Preparing the host machine

The first step in the configuration of the host services is to prepare the machine from which the
Hyper-V service will be running. Note that Sherlock does not require that all services run on this
machine but for the purposes of this post I will assume that this is the case. The configuration of
the host machine consists of:

1. Install the host operating system on the machine. Both the machine and the operating system need to
  [support Hyper-V](https://en.wikipedia.org/wiki/Hyper-V#System_requirements_and_specifications). On
  top of that for the very least the master controller service has to be installed on the host machine,
  which means it is not possible to install the core Hyper-V version of Windows.
1. Create or associate a user which you will use to run the Sherlock services. It is strongly
  recommended to not run the Sherlock services as local administrator for security reasons. It is
  more suitable to provide a separate user to run the services. Note that this user will need
  permissions to run services, but doesn't need installation permissions etc. For the remainder of
  this post lets call this user the *SherlockUser*. *Note:* If you have a specific user that is used
  for your build server then it makes sense to use that user, although that is not required.
1. Install the [Hyper-V role](https://technet.microsoft.com/en-us/library/hh846766.aspx) on the host machine.
1. Grant the *SherlockUser* [permissions](https://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/17/allowing-non-administrators-to-control-hyper-v.aspx)
  to start, stop and reset Hyper-V virtual machines.
1. Install the [IIS role](http://www.iis.net/learn/get-started/whats-new-in-iis-8/installing-iis-8-on-windows-server-2012)
  on the host machine. *Note:* that in theory (i.e. this has not been tested) IIS can be installed
  on a different machine than the host machine as long as it will be able to reach the database. The
  IIS install will need to have the following parts installed as a minimum:
    * ASP .NET 4.5
    * Basic authentication
    * Windows Authentication
    * Management tools
    * Http logging and tracing
1. Install [MSSQL Express 2012](https://www.microsoft.com/web/platform/database.aspx) on the host
  machine. *Note:* As with IIS it is again possible to install the database on any machine as long
  as both IIS and the Hyper-V host can connect to it.
1. Create a directory that will hold all the files related to Sherlock, e.g. `c:\testing`. In that
  directory create the following sub-directories:
    * `appupdate` - Contains the application update files and manifests.
    * `console` - Contains the binary files for the console application which is used by the user to
      register a test.
    * `service` - Contains the binaries for the windows service that will run the controller application.
    * `web.api` - Contains the binaries for the web service that interacts with the database on test registration.
    * `web.intranet` - Contains the binaries for the management web site.
    * `reports` - The location where tests can place their generated reports. Note that Sherlock allows
      placing test reports in any location as long as the service has access to that directory.
    * `temp` - The temporary directory used for report generation etc.
1. Share the `reports` and `console` directories so that they can be accessed over the network. The
  `console` directory will only need read access, the `reports` directory will need read and write access.
1. Install the [nAdoni](https://github.com/pvandervelde/nAdoni) manifest signing tool. This application
  will be used sign the update manifest files.
1. Generate the update keys by executing the following command line (assuming that you installed
  nadoni in `c:\tools\nadoni`):

  ``` dos
  c:\tools\nadoni\keygenerator\nadoni.keygenerator.exe --private=<PATH_TO_PRIVATE_KEY_FILE> --public=<PATH_TO_PUBLIC_KEY_FILE>
  ```
1. Where `<PATH_TO_PRIVATE_KEY_FILE>` points to the XML file that will contain the private and public
  parts of the manifest signing key and `<PATH_TO_PUBLIC_KEY_FILE>` points to the XML file that will
  contain the public part of the manifest signing key.


### Database

The second step in the installation process is to create the Sherlock database.

- Unpack the *sql.zip* file that is part of the [Sherlock release](https://github.com/pvandervelde/Sherlock/releases).
- Create database called `Sherlock`.
- Apply all the SQL scripts from the *sql.zip* file, starting at the V1 script through to the latest
  upgrade script *Sherlock_Upgrade_Vm_To_Vn.sql*.
- Provide permissions for the user that will be connecting to the database. You can either use the
  *SherlockUser* or you can create an SQL user. Grant this user the following access:
    * db_datareader
    * db_datawriter
    * Grant access to stored procedures. This can be done via:
      `GRANT EXEC TO <STORED_PROCEDURE_NAME> TO <SQL_USER>`. Given that Sherlock only accesses the
      database through stored procedures, there is no direct table access, there are quite a few
      stored procedures which means it makes sense to create a script in order to grant access to
      the stored procedures. The following SQL script can be used to generate an access script for
      the user:

    ``` sql
    SELECT  'GRANT EXEC ON '+ SCHEMA_NAME(schema_id) + '.' + name + ' TO <SQL_USER>'
    from sys.procedures
    ORDER BY 1
    ```
- Set-up a back up for the Sherlock database. *Note:* The test data is only useful to Sherlock and
  then only when tests are either running or haven't been run yet. In other words there is no useful
  information for the user describing test results etc.. However the information describing the available
  test environments should be backed-up.


### IIS

Step number three for the installation of Sherlock is to configure the web service, web page and the
application update location. We'll start with the application update location:

- In IIS Manager create a new virtual directory under the default web site using the following settings
    * **Alias:** AppUpdate
    * **Path:** `c:\testing\appupdate`
    * **Connect as:** *SherlockUser*. Make sure the *SherlockUser* has read permissions for the directory.
- Allow directory browsing through the *IIS -> Directory Browsing* Feature.
- Finally test access to this directory via a browser by going to `<HOST_ADDRESS>\AppUpdate`. This
  should display the contents of the directory.

Before configuring the web site and the web service create a new application pool with the following
settings:

- **Name:** SherlockAppPool
- **.NET Framework version:** V4.0.30319
- **Managed pipeline mode:** Integrated

The next project to configure is the web site that will be used to manage the testing environments.

- Unzip **Sherlock.Web.Intranet.sql** to the `c:\testing\web.intranet` directory.
- In IIS Manager create a new application under the default web site using the following settings:
    * **Alias:** Sherlock.Intranet
    * **Application pool:** SherlockAppPool
    * **Path:** `c:\testing\web.intranet`
    * **Connect as:** *SherlockUser*. Again make sure that the *SherlockUser* has access to the
      directory containing the web site binaries.
- Set the authentication for the web site to be anonymous only.
- Define the connection string to be as given below:

<gist>7866267</gist>

- Remove the following sections from the configuration file
    * System.Web -> Authentication
    * System.Web -> Authorization

The last web project to configure is the web service that will be used to add information about the
new tests to the database.

- Unzip **Sherlock.Web.Api.zip** to the `c:\testing\web.api` directory.
- In IIS Manager create a new application under the default web site using the following settings:
    * **Alias:** Sherlock.Api
    * **Application pool:** SherlockAppPool
    * **Path:** `c:\testing\web.api`
    * **Connect as:** *SherlockUser*. Again make sure that the *SherlockUser* has access to the
      directory containing the web service binaries.
- Define the connection string to be the same as given for the management website.
- Set the authentication for the web site to be anonymous only.


### Update manifests and files

The two main services for Sherlock, the master controller and the executor controller, are not
directly installed on either the host machine or the test environments. The Sherlock service probes
the `AppUpdate` directory for the binaries of these services. This greatly improves the ease with
which Sherlock can be upgraded given that an upgrade of Sherlock does not require any changes to
the test environments.

To create the necessary upgrade files for the Sherlock services it will be necessary to update the
configuration file of the master controller which takes the following steps:

- Unzip **Service.Master.zip** into a temporary directory.
- Update the configuration file (`Sherlock.Service.Master.exe.config`) with the following settings:
    * **TestDataDirectory:** `c:\testing\web.api\App_Data`
    * **TestReportFilesDir:** `c:\testing\temp`
- Define the connection string to be the same as given for the management website.
- Repackage the binaries into a ZIP archive with the name **Service.Master.zip**.

The executor controller does not need any changes to the configuration file and can thus be left untouched.

The next step is to create the manifest files that are used by the update service to determine which
ZIP archive to use. In order to create the manifests the [nAdoni](https://github.com/pvandervelde/nAdoni)
application is used. This can be done with the following command lines:

For the master controller:

``` dos
C:\tools\nadoni\manifestbuilder\nAdoni.ManifestBuilder.exe -v="{VERSION}" -n="Sherlock.Service.Master.exe" -f="c:\testing\appupdate\service.master.zip" -u="http://myhostmachine/appupdate/service.master.zip" -k="C:\mykeydirectory\manifestsigningkey.private.xml" -o="c:\testing\appupdate\masterservice.manifest"
```

And for the executor controller:

``` dos
C:\tools\nadoni\manifestbuilder\nAdoni.ManifestBuilder.exe -v="{VERSION}" -n="Sherlock.Service.Executor.exe" -f="c:\testing\appupdate\service.executor.zip" -u="http://myhostmachine/appupdate/service.executor.zip" -k="C:\mykeydirectory\manifestsigningkey.private.xml" -o="c:\testing\appupdate\executorservice.manifest"
```

Another way to create the manifest files is through the use of the following Msbuild script:

<gist>6521946</gist>

In this case the following changes must be made to the file:

- `${PATH_TO_NADONI_DIRECTORY}$` - The path to the directory in which the nAdoni binaries have been placed.
- `${URL_TO_APP_UPDATE}$` - The URL to the `AppUpdate` directory, e.g. `http://myhostmachine/appupdate`.
- `${MANIFEST_SIGNING_KEY_PATH}$` - The path to the XML file that contains the private key information.

And the following properties must be specified on the command line:

- **Version:** The version of Sherlock for which the manifest files are generated.


### Services

Finally on the host machine two applications need to be configured. These are the console application
that will be executed by the user to register a test and the update service that will control the
master controller application.

To configure the console application take the following steps:

- Unzip the **console.zip** package into the `c:\testing\console` directory.
- Open the configuration file (`Sherlock.Console.exe.config`) and update the following settings:
    * **WebServiceUrl:** Point this to the *Sherlock.Api* site, e.g. `http://myhostmachine/sherlock.api`.
- Note that the console needs to be accessed from other machines, e.g.from the build server, so make
  sure that the directory is shared with read-rights for all users that will need access.

To configure the update service take the following steps:

- Unzip the **service.zip** package into the `c:\testing\service` directory.
- Open the configuration file (`Sherlock.Service.exe.config`) and update the following settings:
    * **ApplicationName:** The name of the application for which updates should be tracked, in this
      case that is: `Sherlock.Service.Master.exe`.
    * **UpdateManifestUri:** The URL of the manifest file, in this case: `http:\\myhostmachine\appupdate\masterservice.manifest`
    * **ManifestPublicKeyFile:** The path to the XML file containing the public key section of the
      manifest signing key, e.g. `C:\mykeydirectory\manifestsigningkey.public.xml`
- Install the application as a service by opening an elevated command line and navigating to the
  `c:\testing\service` directory. Then execute the following command line:

        sherlock.service.exe install -username:SherlockUser -password:SherlockPassword --delayed -servicename:Sherlock

- Go to the Windows services control and start the service. After a short while this will grab the
  latest version of the master controller binaries, drop them in `C:\ProgramData\Sherlock\Sherlock.Service.Master`
  and then start the master controller application. You can verify that all is well by checking the
  log files which are located in `C:\ProgramData\Sherlock\Sherlock.Service\{VERSION}\logs` and
  `C:\ProgramData\Sherlock\Sherlock.Service.Master\{VERSION}\logs` for the service and the master
  controller respectively.


### Firewall

The last step is to let the master controller through the firewall. For this create an inbound rule
that allows `Sherlock.Service.Master.exe` to connect to all types of protocols. Normally only Domain
and private networks should be sufficient.

And with all that done the host machine configuration is completed.
