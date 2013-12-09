---
title: 'Setting up Sherlock for regression testing - Verification'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

* Verify that it all works by using the verification tools
 * Test registration separately from test execution so that you can find out easily where any errors are.


* Use testing package (has one failing test, which is easy to 'unfail')
 * At this stage you can only test that the data will end up in the database, because you haven't set up any virtual machines yet. If you look in the Test table then you can see if everything is properly registered.




##Troubleshooting

### Console
* Fail to connect to the web service - Can't find it, check the URL is ok
* Falls over - Configuration problem. Most likely the URL isn't a full URL, always start URL with http.

### Web service

* Fail to connect - problem with permissions on the user(?) Try using a REST tool in a web browser to see if you can connect to the API.
* Fail to store test data - problem with permissions on the App_Data directory

### Virtual machines

* If the service can't start a virtual machine then the *SherlockUser* may not have [permissions](http://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/17/allowing-non-administrators-to-control-hyper-v.aspx) to start the virtual machines. The log will show this as an error in the environment loading. Probably a security exception.
* If the service is blocked by the firewall (or the firewall on the VM is blocking) then there will be no communication between the VM and the host. The log shows this through the fact that the host will wait an excessive (normal start up takes around 2 minutes for a VM + OS load + sherlock load) amount of time for the remote 'endpoint' to connect (cut off time is about 10 minutes)