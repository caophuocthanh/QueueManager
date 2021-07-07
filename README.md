# QueueManager

Beta 1:
- [x] Queue handle with minimum tasks - Remove dublicate task - Recuce tasks excute
- [x] Set duration to ignore tasks
- [x] Make queue faster 

Beta 2:
- [ ] Some tasks have required condition
- [ ] If adapted condition. a task can run immedately


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
//
//
// Queue handle - remove dublicate - make it faster - recuce tasks excute:
//  Combine: => queue[]:  todo - note - event - [kanpan, kanbanitem] - colelctions - (finish 1) - push contact - (finish 2) - push email - (finish 3) - push todo - (finish 4) - (finish 5) - todo - note - event - [kanpab, kanbanitem] - colelctions - (finish 6)


```
