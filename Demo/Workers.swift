//
//  PullWorkers.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue

struct Workers {
    
    public static var email: Worker = {
        let worker = Worker(name: "email") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("✪ makeCompleted  => email")
                makeCompleted()
            }
        }
        worker.duration = 10
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var contact: Worker  = {
        let worker = Worker(name: "contact") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
                print("✪ makeCompleted  => contact")
                makeCompleted()
            }
        }
        worker.duration = 10
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var user: Worker = {
        let worker = Worker(name: "user") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                print("✪ makeCompleted  => user")
                makeCompleted()
            }
        }
        worker.duration = 10
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var settings: Worker = {
        let worker = Worker(name: "settings") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("✪ makeCompleted  => settings")
                makeCompleted()
            }
        }
        worker.duration = 10
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var accounts: Worker = {
        let worker = Worker(name: "accounts") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                print("✪ makeCompleted  => accounts")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var folder: Worker = {
        let worker = Worker(name: "folder") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("✪ makeCompleted  => folder")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var collections: Worker  = {
        let worker = Worker(name: "collections") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                print("✪ makeCompleted  => collections")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var kanban: Worker  = {
        let worker = Worker(name: "kanban") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("✪ makeCompleted  => kanban")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var event: Worker  = {
        let worker = Worker(name: "event") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("✪ makeCompleted  => event")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var note: Worker  = {
        let worker = Worker(name: "note") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
                print("✪ makeCompleted  => note")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    
    public static var todo: Worker = {
        let worker = Worker(name: "todo") { (makeCompleted) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("✪ makeCompleted  => todo")
                makeCompleted()
            }
        }
        worker.duration = 20
        worker.ignore = true
        // worker.queuePriority = .veryHigh
        return worker
    }()
    
    public static var push_email: Worker = {
        let worker = Worker(name: "push_email") { (makeCompleted) in
            
            // closure excute any code
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("✪ makeCompleted  => push_email")
                makeCompleted()
            }
        }
        // duration for next excute
        worker.duration = 0
        // accept ignore after duration time
        worker.ignore = false
        return worker
    }()
    
    public static var push_contact: Worker = {
        let worker = Worker(name: "push_contact") { (makeCompleted) in
            // TODO:
            // Load activities
            // Send request
            // Remove activities after success
            // Maybe send request time 2 seconds
            // emit to UI
            // Finally, makeCompleted()
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("✪ makeCompleted  => push_contact")
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
