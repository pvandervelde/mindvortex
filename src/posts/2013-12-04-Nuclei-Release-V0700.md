Title: Nuclei release - V0.7.0.0
Tags:
  - Nuclei
commentIssueId: 26
---

Version [V0.7.0.0](https://github.com/pvandervelde/Nuclei/releases/tag/V0.7.0.0) of the [Nuclei](/projects/nuclei.html) library has been released. This release adds support for grouping timing results based on their logical area.

``` cs
var group1 = new TimingGroup();
using (Profiler.Measure(group1, "My first timing group"))
{
    var group2 = new TimingGroup();
    using (Profiler.Measure(
        group2,
        "This timing is not a child of the first one"))
    {
        // Do stuff here ...
    }

    using (Profiler.Measure(
        group1,
        "This timing is a child of the first one"))
    {
        // Do stuff here ...
    }
}
```
