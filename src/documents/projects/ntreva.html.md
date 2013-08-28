---
title: 'nTreva'
description: "nTreva is an application that creates an XML file containing license information from installed NuGet packages."
---

[nTreva](https://github.com/pvandervelde/nTreva) is an application that creates an XML file containing license information from installed NuGet packages. To run nTreva use the following command line.

    nTreva.exe -p <Directory_With_Installed_Packages> -o <Output_File> -c <PackageConfigFile1> -c <PackageConfigFile2> ... -c <PackageConfigFileN>

The output will be an file containing information about the installed packages (found in the different package.config files), their project URL and their license URL. If no project or license 
URL is found a default google search URL is generated. An example section as taken from the output file obtained by running nTreva on it's own workspace:

``` xml
<?xml version="1.0" encoding="utf-8" ?>
<packages>
  <package>
    <id>Lokad.Shared</id>
    <version>1.5.181.0</version>
    <url>http://www.google.com/search?q=Lokad.Shared</url>
    <licenseurl>http://www.opensource.org/licenses/bsd-license.php</licenseurl>
  </package>

  <package>
    <id>Nuclei</id>
    <version>0.6.0.0</version>
    <url>https://github.com/pvandervelde/Nuclei</url>
    <licenseurl>http://www.apache.org/licenses/LICENSE-2.0</licenseurl>
  </package>

  <package>
    <id>Nuclei.Build</id>
    <version>0.6.0.0</version>
    <url>https://github.com/pvandervelde/Nuclei</url>
    <licenseurl>http://www.apache.org/licenses/LICENSE-2.0</licenseurl>
  </package>

  <package>
    <id>Nuget.Core</id>
    <version>2.1.1</version>
    <url>http://nuget.codeplex.com/</url>
    <licenseurl>http://nuget.codeplex.com/license</licenseurl>
  </package>

</packages>
```