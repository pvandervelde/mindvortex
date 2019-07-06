Title: Nuclei release - V0.6.7.0
Tags:
  - Nuclei
---


Version [V0.6.7.0](https://github.com/pvandervelde/Nuclei/releases/tag/V0.6.7.0) of the
[Nuclei](/projects/nuclei.html) library has been released. This release fixes a bug in the processing
of `ICommandSet` return tasks which caused the processor to throw an exception if the return task was
a [continuation task](https://msdn.microsoft.com/en-us/library/ee372288.aspx). This bug fix means it
is now possible to chain tasks and return the final task from an `ICommandSet` object. An example of
this behaviour is given in the following section of code.

``` cs
public interface IMyCommandSet : ICommandSet
{
    Task DoSomethingAwesome();
}

public sealed class MyCommand : IMyCommandSet
{
    public Task DoSomethingAwesome()
    {
        var firstTask = Task.Factory.StartNew(
            () => Thread.Sleep(1000));
        var secondTask = firstTask.ContinueWith(
            t => Console.WriteLine("Awesome sauce"));
        return secondTask
    }
}
```
