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
    
    DispatchQueue.global().asyncAfter(deadline: .now() + Double.random(in: 1..<10)) {
        calback()
    }

}

struct Workers {
    
    public static var fetch_task1: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task1", rate_limit: 4, ignore: true, retry: 3) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task1 is finish in \(measure) seconds.")
                makeCompleted(.failure(NSError(domain: "push_task1 error", code: 100)))
            }
        }
        return worker
    }()
    
    public static var fetch_task2: QueueManager.Worker  = {
        return QueueManager.Worker(name: "fetch_task2", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task2 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task2"))
            }
        }
    }()
    
    public static var fetch_task3: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task3", rate_limit: 4, ignore: true, retry: 3) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task3 is finish in \(measure) seconds.")
                makeCompleted(.failure(NSError(domain: "push_task3 error", code: 100)))
            }
        }
        return worker
    }()
    
    public static var fetch_task4: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task4", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task4 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task4"))
            }
        }
        
        return worker
    }()
    
    
    public static var fetch_task5: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task5", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task5 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task5"))
            }
        }
        return worker
    }()
    
    public static var fetch_task6: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task6", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task6 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task6"))
            }
        }
        return worker
    }()
    
    
    public static var fetch_task7: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task7", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task7 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task7"))
            }
        }
        return worker
    }()
    
    
    public static var fetch_task8: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task8", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task8 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task8"))
            }
        }
        return worker
    }()
    
    
    public static var fetch_task9: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task9", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task9 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task9"))
            }
        }
        return worker
    }()
    
    public static var fetch_task10: QueueManager.Worker  = {
        let worker = QueueManager.Worker(name: "fetch_task10", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task10 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task10"))
            }
        }
        return worker
    }()
    
    
    public static var fetch_task11: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "fetch_task11", rate_limit: 4, ignore: true) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task11 is finish in \(measure) seconds.")
                makeCompleted(.success("hello fetch_task11"))
            }
        }
        return worker
    }()
    
    public static var push_task1: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "push_task1", rate_limit: 0, ignore: false) { (makeCompleted) in
            
            // closure excute any code
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => push_task1 is finish in \(measure) seconds.")
                makeCompleted(.failure(NSError(domain: "push_task1 error", code: 100)))
            }
        }
        return worker
    }()
    
    public static var push_task2: QueueManager.Worker = {
        let worker = QueueManager.Worker(name: "push_task2", rate_limit: 0, ignore: false, retry: 1) { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => push_task2 is finish in \(measure) seconds.")
                makeCompleted(.success("hello push_task2"))
            }
        }
        return worker
    }()
    
}
