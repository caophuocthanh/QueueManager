//
//  PullWorkers.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue


func request(calback: @escaping () ->  Void) {
//    let url = URL(string: "https://www.google.com.vn/search?q=github+magic+mirror+2&sxsrf=ALeKk02T6kqo8AcOIfnqtXvkr9dNRB4Olg%3A1627004796331&source=hp&ei=fB_6YLDOEfaP4-EPlYyAsAs&iflsig=AINFCbYAAAAAYPotjFvPIANGC4cyYfKhLbEGggREGbaA&oq=githu&gs_lcp=Cgdnd3Mtd2l6EAMYADIECCMQJzIHCAAQsQMQQzIHCAAQsQMQQzIECAAQQzIECAAQQzIFCAAQywEyBQgAELEDMgUIABDLATICCAAyAggAOgoIABCxAxCDARBDOggIABCxAxCDAVDWM1ikOGC6RmgAcAB4AIABhAGIAaIEkgEDMS40mAEAoAEBqgEHZ3dzLXdpeg&sclient=gws-wiz")!
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        calback()
//    }
//    task.resume()
    
    let wait = DispatchSemaphore(value: 0)
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        calback()
        wait.signal()
    }
    wait.wait()
    
    
}

struct Workers {
    
    public static var fetch_task1: Worker = {
        let worker = Worker(name: "fetch_task1") { (makeCompleted) in
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task1 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task2 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task3 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task4 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task5 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task6 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task7 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task8 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task9 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task10 is finish in \(measure) seconds.")
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
            let start = CFAbsoluteTimeGetCurrent()
            request {
                let measure = CFAbsoluteTimeGetCurrent() - start
                print("✪ makeCompleted  => fetch_task11 is finish in \(measure) seconds.")
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
    
    public static var push_task2: Worker = {
        let worker = Worker(name: "push_task2") { (makeCompleted) in
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
