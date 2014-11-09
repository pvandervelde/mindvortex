---
title: 'Creating Azure VM images with Powershell'
tags: ['Powershell', 'Azure']
commentIssueId: 5000
ignored: true
---

As part of a new [project](https://github.com/pvandervelde/azure-jenkins) to create a [Jenkins CI server](http://jenkins-ci.org/) on Azure I am writing a set of powershell scripts to control virtual machines on Azure. For this project the plan is to use virtual machine (VM) images as a template for an ['immutable server'](http://martinfowler.com/bliki/ImmutableServer.html) that will contain the Jenkins instance. 

Obviously the actual server isn't really 'immutable' given that the jenkins instance will update / add / delete files on the hard drive which will change the state of the server. The immutable idea isn't applied to the whole server but more to the configuration part of the server. The idea being that the configuration of the server will not be changed once the server is created. Any configuration changes (e.g. a new version of Jenkins) will be done by creating a new image, spinning up a new server based on that image and then destroying the old server and replacing it with the new one.  

In order to create a suitable image we will need to build an image with all the required software on it and then verify that this image has indeed been created correctly.

To create the image we first obtain a certificate that can be used for the WinRM SSL connection between the Azure VM and the local machine that is executing the creation scripts. You can either get an official one or you can use a self-signed certificate (which is obviously less secure). Two things of interest are: 

* The certificate needs to have an [exportable](http://consultingblogs.emc.com/gracemollison/archive/2010/02/19/creating-and-using-self-signed-certificates-for-use-with-azure-service-management-api.aspx) private key because otherwise it cannot be used for the WinRM connection.
* The certificate needs to be named after the connection that you expect to make. For a connection to an Azure VM this will most likely be something like `<RESOURCE_GROUP_NAME>.cloudapp.net`. 

Once the certificate is installed in the user certificate store we can create a new virtual machine from a given base image, e.g. a Windows 2012 R2 server image. The following powershell function creates a new windows VM with a WinRM endpoint with the certificate that was created earlier. Note that the [`New-AzureVM`](http://msdn.microsoft.com/en-us/library/dn495254.aspx) function can create resource and storage groups for the new VM if you don't specify a storage account and a matching resource group.

<gist>1153f249115780ed2b99</gist>

Once the VM is running a new Powershell remote session can be opened to the machine in order to start the configuration of the machine. Note that this approach only seems to be working for `https` connections because the `Get-AzureWinRMUri` function only returns the `https` URI. Hence the need for a certificate that can be used to secure the connection.

<gist>eb6e28934d5fd16fe186</gist>




* Create the image. Steps:

    * Copy all files to the remote over the [remoting channnel](http://measureofchaos.wordpress.com/2012/09/26/copying-files-via-powershell-remoting-channel/)
    * Execute the installation scripts (via Puppet, Chef, DSC or just plain old powershell)
    * Sysprep the machine. Note that this has to be done from a script that lives on the VM, you can't just send a sysprep command to the machine because [apparently]() sysprep starts but will just exit instead of doing work.
    * Once the machine has shut down grab an image from it
* Test that the image is actually correct. Steps:
    * Use the newly created image to create a new VM (using the same steps as for the creation, except using the new image instead of the standard base image)
    * Execute a verification script that verifies that all desired applications / settings have been applied and that nothing is left behind that shouldn't be.


