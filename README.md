# QueueManager

## Feature:

Beta 1:
- [x] Can set a scenario to execute.
- [x] Queue can run with many scenarios inside.
- [x] State of the queue: working, resting.
- [x] Callback when a scenario is done.  
- [x] Callback when a task is done. Can add listen to callback much time.
- [x] Queue handle with minimum tasks - Remove duplicate task - Reduce tasks to execute.
- [x] Set duration to ignore tasks. Or set ignore == false
- [x] A lib can easier to apply to an existing project.

Beta 2:
- [ ] A task can have required condition tasks these must be done before running this task.
- [ ] If task adapted conditions. A task can run immediately. No need to wait its turn


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
