Title: Technical Debt - Thoughts
Tags:
  - Packer
  - Hyper-V
  - Infrastructure-as-code
  - DevOps
---

* Dealing with a lot of tech debt in my jobs

* Nearly everybody is familiar with the term technical debt by now
  * Definition:
* Every company has some quantity of technical debt. Some have less, some have more, some have
  lots more
* Some companies take it very seriously, many do not
  * Hard to sell technical debt and fixing it to management

* Code that only changes infrequently is interesting
  * It needs an owner, so somebody is responsible. That means these people need to be available
    to make changes, but often there is not enough work so we need to assign them other work.
    * That means there's a management overhead to do prioritization
    * Even worse if this 'team' maintains many of these things, then priorities clash
  * Infrequently changed code also means that it will take the engineers a while to re-acquaint
    themselves with the code
    * So infrequently changed code should ironically have really good unit tests and documentation.
      In reality it has neither of those things because it's often code that was quickly thrown together
* Infrastructure can have tech debt too
* Bad naming is everywhere
* code is a liability


* One reason that technical debt doesn't get resolved is that the pain from the debt isn't obvious
  * It's hard to measure / turn into real numbers. Quite often the debt makes for pain for the development
    team while they're doing other work (Yak shaving). It's often hard to attribute specific time
    blocks to be technical debt vs technical issues with the current work
  * The immediate pain from the technical debt often stops at the development team, it rarely makes
    its way up high enough that it becomes a priority
* Q: how do we make the pain visible for everyone in the company
* Q: is the technical debt actually as bad as the technical people say it is
* Q: which metrics should be tracked to figure out how bad the technical debt is
* Q: levels of technical debt

- Little things matter even if you think they don't matter
  - Version numbers: If the business has control over the version number they might not want to
    change it because the customer doesn't like the major version changes, then the version number
    is changed differently. Additionally the major changes are then done with a minor version change
    or things like that. The same changes are going out just the number lies. This then confuses people
    / people use additional brain power to keep this weird config in mind
  - Quite often small things are treated as inconsequential, however higher order effects are a thing,
    and for some things, higher order rules
  - Naming of things. Soon there will be a proliferation and often we don't thing about a naming
    pattern at the beginning. Additionally names are often hard to change, patterns are even harder
    to change

- Tech debt removal
  - Is it worth it? Depends on if we're going to alter the thing, often we are because software
    is constantly evolving
  - Don't use the assumption that something will disappear soon because of new systems being introduced
    - It always takes much longer for the new thing to be introduced and fully replaces the old thing
  - Are quick / short improvements worth it, or do they create more tech debt
    - They will solve the immediate problem, but might just introduce more issues later on