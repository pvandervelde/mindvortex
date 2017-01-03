Title: nAnicitus release - V0.1.5
Tags:
   - nAnicitus
commentIssueId: 38
---

Version [V0.1.5](https://github.com/pvandervelde/nAnicitus/releases/tag/0.1.5) of the [nAnicitus](/projects/nanicitus.html) symbol store application has been released.

This release fixes the following issues:

* [#4](https://github.com/pvandervelde/nAnicitus/issues/4) - Switch versioning scheme to use Semantic Versioning. The version is automatically calculated from the previous version tags in the repository with the [GitHubFlowVersion](https://github.com/JakeGinnivan/GitHubFlowVersion) tool.
* [#6](https://github.com/pvandervelde/nAnicitus/issues/6) - Mark all files as read-only. All source files which are copied to the the UNC directory are now marked as read-only so that users won't be able to change them.
* [#7](https://github.com/pvandervelde/nAnicitus/issues/7) - Srctool last message not stripped when finding source paths in PDB
* [#8](https://github.com/pvandervelde/nAnicitus/issues/8) - PDB embedded sourceserver file path calculation doesn't match server path. The source server file path is now calculated for each embedded file, instead of using a single directory reference for all files.
* [#10](https://github.com/pvandervelde/nAnicitus/issues/10) - Automatically create release notes from resolved GitHub issues. The release notes are created by finding all issues that have been closed between the previous and the current tag. This is using [GitReleaseNote](https://github.com/JakeGinnivan/GitReleaseNotes) tool.
