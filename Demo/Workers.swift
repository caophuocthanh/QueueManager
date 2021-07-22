//
//  PullWorkers.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue




func request(calback: @escaping () ->  Void) {
    let url = URL(string: "https://google.com")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        calback()
    }
    task.resume()
}

struct Workers {
    
    public static var fetch_task1: Worker = {
        let worker = Worker(name: "fetch_task1") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task1")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var fetch_task2: Worker  = {
        let worker = Worker(name: "fetch_task2") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task2")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var fetch_task3: Worker = {
        let worker = Worker(name: "fetch_task3") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task3")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var fetch_task4: Worker = {
        let worker = Worker(name: "fetch_task4") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task4")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var fetch_task5: Worker = {
        let worker = Worker(name: "fetch_task5") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task5")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var fetch_task6: Worker = {
        let worker = Worker(name: "fetch_task6") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task6")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var fetch_task7: Worker  = {
        let worker = Worker(name: "fetch_task7") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task7")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var fetch_task8: Worker  = {
        let worker = Worker(name: "fetch_task8") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task8")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var fetch_task9: Worker  = {
        let worker = Worker(name: "fetch_task9") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task9")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var fetch_task10: Worker  = {
        let worker = Worker(name: "fetch_task10") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task10")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var fetch_task11: Worker = {
        let worker = Worker(name: "fetch_task11") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => fetch_task11")
                makeCompleted()
            }
        }
        worker.duration = 12
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var push_task1: Worker = {
        let worker = Worker(name: "push_task1") { (makeCompleted) in
            
            // closure excute any code
            request {
                print("✪ makeCompleted  => push_task1")
                makeCompleted()
            }
        }
        // duration for next excute
        worker.duration = 0
        // accept ignore after duration time
        worker.ignore = false
        return worker
    }()
    
    public static var push_task2: Worker = {
        let worker = Worker(name: "push_task2") { (makeCompleted) in
            request {
                print("✪ makeCompleted  => push_task2")
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
