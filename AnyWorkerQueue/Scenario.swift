//
//  ScenarioWorker.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit

public extension QueueManager {
    
    enum Task {
        case sync(Worker)
        case async([Worker])
    }
    
    class Scenario {
        
        internal var name: String
        internal var tasks: [Task]
        
        
        internal let beginWorker: Worker
        internal let endWorker: Worker
        
        internal var start_mearsure: Double = CFAbsoluteTimeGetCurrent()
        
        public init(name: String, tasks: [Task], completed: @escaping () -> Void) {
            self.name = name
            self.tasks = tasks
            
            self.beginWorker = Worker(name: "\(name)_begin") { (makeCompleted) in
               print("\n\n\nScenario [\(name)] begin")
                makeCompleted()
            }

            self.beginWorker.operation.queuePriority = .veryHigh
            self.beginWorker.duration = 0
            self.beginWorker.ignore = false
            self.tasks.insert(.sync(self.beginWorker), at: 0)
            
            self.endWorker = Worker(name: "\(name)_finish") { (makeCompleted) in
                makeCompleted()
            }


            self.endWorker.completed {
                self.tasks = []
                print("\(Date()) Scenario: [\(self.name)] finish in", CFAbsoluteTimeGetCurrent() - self.start_mearsure, "seconds")
                completed()
            }
            

            self.endWorker.operation.queuePriority = .veryHigh
            self.endWorker.duration = 0
            self.endWorker.ignore = false
            self.tasks.append(.sync(self.endWorker))
        }

        deinit {
            print("\(Date()) Scenario: [\(self.name)] deinit\n\n\n\n\n")
        }
        
    }
   
}
