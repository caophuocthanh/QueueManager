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
        
        
        Workers.email.completed {
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
        
        
//        (1) -- todo - note - event - [kanpan, kanban item] - colelctions
//        (1s):[
//            (2) -- todo - note - event - push contact
//            (3) -- todo - note - event - push email
//            (4) -- todo - note - event - push todo
//            (5) -- todo - note - event - [kanpab, kanbanitem] - colelctions
//        ]
//        (60s):
//        (6) -- todo - note - event - [kanpab, kanbanitem] - colelctions
//        combine: => queue[]:  todo - note - event - [kanpan, kanbanitem] - colelctions - (finish 1) - push contact - (finish 2) - push email - (finish 3) - push todo - (finish 4) - (finish 5) - todo - note - event - [kanpab, kanbanitem] - colelctions - (finish 6)
       
        
    }
    
    
    func intervalSync(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "\(Date().timeIntervalSince1970)_interval sync",
            tasks: [
                .sync(Workers.email),
                .async([
                    Workers.note,
                    Workers.kanban,
                    Workers.event,
                    Workers.folder,
                    Workers.collections,
                    Workers.settings,
                    Workers.todo,
                ]),
                .sync(Workers.contact)
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
                    Workers.note,
                    Workers.event,
                    Workers.kanban,
                ]),
                .sync(Workers.push_email)
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
                    Workers.email,
                    Workers.folder,
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

