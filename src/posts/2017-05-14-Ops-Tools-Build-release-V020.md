Title: Ops-Tools-Build release - V0.2.0
Tags:
  - Ops-Tools-Build
  - Ops-Resource
---

Version [0.2.0](https://github.com/ops-resource/ops-tools-build/releases/tag/0.2.0) of the
[Ops-Tools-Build](https://github.com/ops-resource/ops-tools-build) toolkit was released.

This release was focussed on providing the capabilities to use the Chef toolset to create new
resources. All the work items that have been closed for this release can be found on
[GitHub](https://github.com/ops-resource/ops-tools-build/milestone/2?closed=1).


### New functionality

- [5](https://github.com/ops-resource/ops-tools-build/issues/5) - A new function which provides
  the ability to execute [ChefSpec](https://github.com/sethvargo/chefspec) tests.
- [6](https://github.com/ops-resource/ops-tools-build/issues/6) - A new function which
  invokes the Chef linting tool [Foodcritic](https://www.foodcritic.io/) on the selected Chef cookbooks.
- [7](https://github.com/ops-resource/ops-tools-build/issues/7) - A new function which invokes the
  Ruby linting tool [RuboCop](https://github.com/bbatsov/rubocop) on selected Ruby source files.
- [20](https://github.com/ops-resource/ops-tools-build/issues/20) - A new package restore script
  was added to allow restoring Chef cookbooks via [Berkshelf](https://github.com/berkshelf/berkshelf).
- [21](https://github.com/ops-resource/ops-tools-build/issues/21) - A new switch was added to the
  packer function which allows keeping the resources generated with packer in case the packer
  build fails. This improves the ability to debug issues in the packer build.
