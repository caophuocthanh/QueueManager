# QueueManager

## Feature:

Beta 1:
- [x] Can set an scenario to excute.
- [x] Queue can run with many scenarios inside.
- [x] Queue handle with minimum tasks - Remove duplicate task - Reduce tasks to excute.
- [x] Set duration to ignore tasks. Or set irgnore == false
- [x] A lib can easier to apply to a exist project.

Beta 2:
- [ ] A task can have required condition tasks thesse must done before run this task.
- [ ] If task adapted conditions. A task can run immedately. No need to wait its turn


## Code:
- Lib
- Demo


## How it work:

```
// Interaction:
//        (1) -- todo - note - event - [kanpan, kanban item] - colelctions
//        (1s):[
//            (2) -- todo - note - event - push contact
//            (3) -- todo - note - event - push email
//            (4) -- todo - note - event - push todo
//            (5) -- todo - note - event - [kanpab, kanbanitem] - colelctions
//        ]
//        (60s):
//        (6) -- todo - note - event - [kanpab, kanbanitem] - colelctions
//
```

Some tasks is not add to queue.

```
// Queue handle - remove dublicate - make it faster - recuce tasks excute:
//  Combine: => queue[]:  todo - note - event - [kanpan, kanbanitem] - colelctions - (finish 1) - push contact - (finish 2) - push email - (finish 3) - push todo - (finish 4) - (finish 5) - todo - note - event - [kanpab, kanbanitem] - colelctions - (finish 6)


```
