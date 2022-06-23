//
//  PullWorkers.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue


func request(calback: @escaping () ->  Void) {
//    let url = URL(string: "https://www.google.com")!
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        calback()
//    }
//    task.resume()
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
        calback()
    }
    
//    let wait = DispatchSemaphore(value: 0)
//    DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
//        calback()
//        wait.signal()
//    }
//    wait.wait()
    
    
}

struct Workers {
    
    public static var fetch_task1: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task1") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task1 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var fetch_task2: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task2") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task2 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var fetch_task3: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task3") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task3 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var fetch_task4: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task4") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task4 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    
    public static var fetch_task5: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task5") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task5 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var fetch_task6: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task6") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task6 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    
    public static var fetch_task7: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task7") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task7 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    
    public static var fetch_task8: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task8") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task8 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    
    public static var fetch_task9: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task9") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task9 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var fetch_task10: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task10") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task10 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    
    public static var fetch_task11: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task11") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task11 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        worker.duration = 4
        worker.ignore = true
        
        return worker
    }()
    
    public static var push_task1: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "push_task1") { (makeCompleted) in
            
            // closure excute any code
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => push_task1 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        // duration for next excute
        worker.duration = 0
        // accept ignore after duration time
        worker.ignore = false
        return worker
    }()
    
    public static var push_task2: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "push_task2") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => push_task2 is finish in \(measure) seconds.")
                makeCompleted()
            }
        }
        // duration for next excute
        worker.duration = 0
        // accept ignore after duration time
        worker.ignore = false
//        // timeout
//        worker.timeout = 30 // seconds
//        // retry
//        worker.retry = 1
        return worker
    }()
    
}
