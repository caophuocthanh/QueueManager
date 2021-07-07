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

Input:

```
   (begin):
        (#1) -- task1 - task2 - task3 - [task4, task5, task6] - task7
   (after 1s):
        [
            (#2) -- task1 - task2 - task3 - task8
            (#3) -- task1 - task2 - task3 - task9
            (#4) -- task1 - task2 - task3 - task10
            (#5) --task1 - task2 - task3 - [task4, task5, task6] - task7
        ]
   (after 60s):
        (#6) -- task1 - task2 - task3 - [task4, task5, task6] - task7
        
        
    // with task8, task9, task10 set irnore = false

```

 After prepare and will excute:

```
queue[]:  task1 - task2 - task3 - [task4, task5, task6] - task7 - (finish #1) - task8 - (finish #2) - task9 - (finish #3) - task10- (finish #4) - (finish #5) - task1 - task2 - task3  - [task4, task5, task6] - task7 - (finish #6)
 - (finish #6)

```

So, with the scenario #2 , #3, #5, #5. the scenario not execute  todo - note - event. The scenario run faster.
After 60s, todo - note - event. more than duration. The tasks todo - note - event can run with another scenario.

# How to use:

Import

``` swift
#import AnyQueueManager
```


Define workers

```
    public static var task1: Worker = {
        let worker = Worker(name: "task1") { (makeCompleted) in
            // TODO:
            // Hanlde task here
            // Finally, makeCompleted()
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("✪ makeCompleted  => push_contact")
                makeCompleted()
            }
        }
        // Duration for next excute
        worker.duration = 0
        // Accept ignore after duration time
        worker.ignore = false
        return worker
    }()

```
Create a scenario

```swift

    func scenario() {
        return QueueManager.Scenario(
            name: "\(Date().timeIntervalSince1970)_scenario",
            tasks: [
                .async([
                    task1,
                    task2,
                    task3,
                ]),
                .sync(task4)
            ],
            completed: {
                print("first sync completed \n\n\n\n")
            })
    }

```

Execute

```swift
       let scenario = scenario()
        QueueManager.run(scenario)
```

