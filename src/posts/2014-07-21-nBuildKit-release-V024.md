Title: nBuildKit release - V0.2.4
Tags:
  - nBuildKit
commentIssueId: 43
---

Version [V0.2.4](https://github.com/pvandervelde/nBuildKit/releases/tag/0.2.4) of the [nBuildKit](/projects/nbuildkit.html) build library has been released.

This release introduces NuGet packages that allow Visual Studio [C#](https://www.nuget.org/packages/nBuildKit.MsBuild.Projects.CSharp/) and [WiX](https://www.nuget.org/packages/nBuildKit.MsBuild.Projects.WiX/) projects to share a common configuration including code analysis and strong naming capabilities and to generate one or more source files before building the project.

Both packages provide the ability to share a configuration between multiple projects in a Visual Studio solution. The shared configuration can contain items like Debug and Release settings, targeted .NET framework, code analysis settings and many other options.

Beyond that the C# NuGet package provides capabilities to:

* Generate `AssemblyInfo.XXXX.cs` files for:
 * `AssemblyInfo.VersionNumber.cs` contains the version numbers for the project as determined by nBuildKit from the versioning strategies provided. Currently supported are either a version number provided through an MsBuild project file or through [GitHubFlowVersion](https://github.com/JakeGinnivan/GitHubFlowVersion). By allowing nBuildKit to generate the `AssemblyInfo.VersionNumber.cs` file it is possible to automatically version the binaries the same way as all other artifacts, e.g. NuGet packages, installers, documentation etc. etc.. The version number is currently provided through the [AssemblyVersionAttribute][assembly_version_attribute] as `Major.Minor.0.0`; through the [AssemblyFileVersionAttribute][assembly_file_version_attribute] as `Major.Minor.Patch.Build`; and through the [AssemblyInformationalVersionAttribute][assembly_informational_version_attribute] as the full [semantic version](http://semver.org/).
 * `AssemblyInfo.BuildInformation.cs` contains information about the current build of the binaries. This includes the configuration, e.g. Release; the date and time that the binary was compiled and information describing the build number and the commit number that were used to generate the binaries.
 * `AssemblyInfo.InternalsVisibleTo.cs` contains the [InternalsVisibleToAttribute][internals_visible_to_attribute] values for any assemblies that should have access to the internals of the current assembly for purposes of unit testing.
 * `AssemblyInfo.Company.cs` contains the information describing the 'company' that created the binaries. The information includes the [AssemblyCompanyAttribute][assembly_company_attribute] and the [AssemblyCopyrightAttribute][assembly_copyright_attribute].
* Generate a `CompanyInformation.cs` source file that contains an internal static class providing constants for the company name and the company URL.
* Generate a `ProductInformation.cs` source file that contains an internal static class providing constants for the name of the product.
* Generate an `app.manifest` file with the current project version number.

And the WiX NuGet package provides capabilities to

* Generate a `VersionNumber.wxi` WiX include file that contains the version numbers for the application and the installer.
* Generate a `CompanyInformation.wxi` WiX include file that contains the name and URL of the company that produces the product.
* Generate a `ProductInformation.wxi` WiX include file that contains the name and description of the product.

The generation of all of these files can be enabled through a setting in the `settings.props` file that is also used by the [nBuildKit.MsBuild](https://www.nuget.org/packages/nBuildKit.MsBuild/) NuGet package

The documentation for this library can be found on the nBuildKit [wiki](https://github.com/pvandervelde/nBuildKit/wiki/MsBuild)

[assembly_version_attribute]: http://msdn.microsoft.com/en-us/library/system.reflection.assemblyversionattribute(v=vs.110).aspx
[assembly_file_version_attribute]: http://msdn.microsoft.com/en-us/library/system.reflection.assemblyfileversionattribute(v=vs.110).aspx
[assembly_informational_version_attribute]: http://msdn.microsoft.com/en-us/library/system.reflection.assemblyinformationalversionattribute(v=vs.110).aspx
[internals_visible_to_attribute]: http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.internalsvisibletoattribute(v=vs.110).aspx
[assembly_company_attribute]: http://msdn.microsoft.com/en-us/library/system.reflection.assemblycompanyattribute(v=vs.110).aspx
[assembly_copyright_attribute]: http://msdn.microsoft.com/en-us/library/system.reflection.assemblycopyrightattribute(v=vs.110).aspx
