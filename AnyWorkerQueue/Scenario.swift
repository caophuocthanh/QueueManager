//
//  ScenarioWorker.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit

internal extension DispatchQueue {
    static let waitQueue: DispatchQueue = {
        let queue = DispatchQueue(
            label: "WaitingQueue",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .workItem,
            target: nil
        )
        return queue
    }()
}

public extension QueueManager {
    
    enum Task {
        case wait(DispatchTimeInterval)
        case sync(Worker)
        case async(String, [Worker])
    }
    
    class Scenario: Hashable {
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
        }
        
        public static func ==(lhs: QueueManager.Scenario, rhs: QueueManager.Scenario) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        internal var name: String
        internal var tasks: [Task]
        
        
        internal var endWorker: Worker
        internal var completed: () -> Void
        
        internal var start_mearsure: Double = CFAbsoluteTimeGetCurrent()
        
        internal var workers: [Worker] {
            var workers: [Worker] = []
            for task in self.tasks {
                switch task {
                case .wait(_): break
                case .sync(let w):
                    workers.append(w)
                case .async(_, let ws):
                    workers += ws
                }
            }
            workers.removeLast()
            return workers
        }
        
        public init(name: String, tasks: [Task], completed: @escaping () -> Void) {
            self.name = name
            self.tasks = tasks
            self.completed = completed
            
            self.endWorker = Worker(name: "\(name)_\(UUID().uuidString)_finish") { (makeCompleted) in
                makeCompleted(.success(nil))
            }
            
            self.endWorker.completed { _ in
                self.workers.forEach { (worker) in
                    worker.completedCalbacks = []
                    worker.startCalbacks = []
                }
                self.tasks = []
                print("\(Date()) 🥰🥰🥰 Scenario: [\(self.name)] finish in", CFAbsoluteTimeGetCurrent() - self.start_mearsure, "seconds")
                self.completed()
            }
            
            self.endWorker.queuePriority = .normal
            self.tasks.append(.sync(self.endWorker))
        }
        
        deinit {
            print("Scenario: [\(self.name)] deinit")
        }
        
    }
    
}
