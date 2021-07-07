//
//  ViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        Workers.pull_task1.completed {
            print("🥉 w1 => calback")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let intervalSync = self.intervalSync {
                print("\n\n\n🍎🍎🍎🍎🍎 interval sync done")
            }
            QueueManager.run(intervalSync)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for i in 0...3 {
                
                //
                let pushEmail = self.pushEmail {
                    print("\n\n\n🌦🌦🌦🌦🌦 push [\(i)] email done")
                }
                QueueManager.run(pushEmail)
                
                let pushContact = self.pushContact {
                    print("\n\n\n🏓🏓🏓🏓🏓 push [\(i)] contact done")
                }
                QueueManager.run(pushContact)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let pushEmail = self.intervalSync {
                print("\n\n\n😍😍😍😍😍 interval 2 sync done")
            }
            QueueManager.run(pushEmail)
        }
        
    }
    
    
    func intervalSync(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "\(Date().timeIntervalSince1970)_interval sync",
            tasks: [
                .sync(Workers.pull_task1),
                .async([
                    Workers.note,
                    Workers.kanban,
                    Workers.event,
                    Workers.fetch_task6,
                    Workers.collections,
                    Workers.pull_task4,
                    Workers.todo,
                ]),
                .sync(Workers.pull_task2)
            ],
            completed: {
                //print("interval sync completed\n\n\n\n")
                completed()
            })
    }
    
    func pushEmail(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "\(Date().timeIntervalSince1970)_push email",
            tasks: [
                .async([
                    Workers.fetch_task10,
                    Workers.fetch_task9,
                    Workers.fetch_task8,
                ]),
                .sync(Workers.push_task1)
            ],
            completed: {
                //print("first sync completed \n\n\n\n")
                completed()
            })
    }
    
    func pushContact(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "\(Date().timeIntervalSince1970)_push contact",
            tasks: [
                .async([
                    Workers.pull_task1,
                    Workers.fetch_task6,
                    Workers.kanban,
                ]),
                .sync(Workers.push_contact)
            ],
            completed: {
                //print("first sync completed \n\n\n\n")
                completed()
            })
    }
    
    
}

