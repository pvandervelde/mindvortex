Title: Creating Azure VM images with Powershell
Tags:
  - Powershell
  - Azure
---

As part of a new [project](https://github.com/pvandervelde/azure-jenkins) to create a [Jenkins CI server](http://jenkins-ci.org/) on Azure I am writing a set of powershell scripts to control virtual machines on Azure. For this project the plan is to use virtual machine (VM) images as a template for an ['immutable server'](http://martinfowler.com/bliki/ImmutableServer.html) that will contain the Jenkins instance.

Now the actual server isn't really 'immutable' given that the jenkins instance will update, add and delete files on the hard drive which will obviously change the state of the server. As such the immutable idea isn't applied to the whole server but more to the configuration part of the server. The idea being that the configuration of the server will not be changed once the server is put in production. Any configuration changes (e.g. a new version of Jenkins) will be done by creating a new image, spinning up a new server based on that image and then destroying the old server and replacing it with the new one.

So in order to achieve this goal the first step will be to build an image with all the required software on it and then verify that this image has indeed been created correctly.

To create the image we first obtain a certificate that can be used for the WinRM SSL connection between the Azure VM and the local machine that is executing the creation scripts. You can either get an official one or you can use a self-signed certificate (which is obviously less secure). Two things of interest are:

* The certificate needs to have an [exportable](http://consultingblogs.emc.com/gracemollison/archive/2010/02/19/creating-and-using-self-signed-certificates-for-use-with-azure-service-management-api.aspx) private key because otherwise it cannot be used for the WinRM connection.
* The certificate needs to be named after the connection that you expect to make. For a connection to an Azure VM this will most likely be something like `<RESOURCE_GROUP_NAME>.cloudapp.net`.

Once the certificate is installed in the user certificate store we can create a new virtual machine from a given base image, e.g. a Windows 2012 R2 server image. The following powershell function creates a new windows VM with a WinRM endpoint with the certificate that was created earlier. Note that the [`New-AzureVM`](http://msdn.microsoft.com/en-us/library/dn495254.aspx) function can create resource and storage groups for the new VM if you don't specify a storage account and a matching resource group.

<gist>1153f249115780ed2b99</gist>

Once the VM is running a new Powershell remote session can be opened to the machine in order to start the configuration of the machine. Note that this approach only seems to be working for `https` connections because the `Get-AzureWinRMUri` function only returns the `https` URI. Hence the need for a certificate that can be used to secure the connection.

<gist>eb6e28934d5fd16fe186</gist>

The next step is to copy all the installer files and configuration scripts to the VM. This can be done over the [remoting channnel](http://measureofchaos.wordpress.com/2012/09/26/copying-files-via-powershell-remoting-channel/).

<gist>b2f5b4156e5efe67f495</gist>

Once all the required files have been copied to the VM the configuration of the machine can be started. This can be done in many different ways, e.g through the use of a [configuration](https://www.getchef.com/) [management](http://puppetlabs.com/) [tool](http://technet.microsoft.com/en-us/library/dn249912.aspx) or just via the use of plain old scripts. When the configuration is complete and all the necessary clean-up has been done the time has come to turn the VM into an image. Before doing that a Windows machine will have to be [sysprepp'ed](http://en.wikipedia.org/wiki/Sysprep) so that there are no unique identifiers in the image (and thus in the copies).

In order to sysprep an Azure VM it is necessary to execute the sysprep command through a script on the VM because sysprep [fails](http://blogs.msdn.com/b/brocode/archive/2014/06/20/how-to-automate-sysprep-of-an-iaas-vm-on-microsoft-azure.aspx) if the command is given directly through the remoting channel. The following function creates a new Powershell script which invokes sysprep, copies that to the VM and then executes that script. Once sysprep has completed running the machine will be turned off and an image can be created.

<gist>349767f804a32195ee67</gist>

The next step is to test the new image in order to verify that all configuration changes have been applied correctly. The explanation of how the testing of an virtual machine image works is a topic for the next blog post.


