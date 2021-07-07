//
//  AnyWorkerQueue.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit


public class QueueManager {
    
    public enum State {
        case working
        case resting
    }
    
    internal static var lasttimeExcuteWorker: [String: Double] = [:]
    
    internal func lastExcuateOperation(by name: String) -> Double {
        return QueueManager.lasttimeExcuteWorker[name] ?? 0
    }
    
    public static func run(_ scenario: QueueManager.Scenario) {
        print("\n\n\(Date()) Scenario: \(scenario.name) run.")
        scenario.start_mearsure = CFAbsoluteTimeGetCurrent()
        QueueManager.default.add(scenario: scenario)
    }
    
    internal static let `default`: QueueManager = QueueManager()
    
    public var state:QueueManager.State = .resting {
        didSet {
            print("==> queue state:", self.state)
        }
    }
    
    internal let operationSerialQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name =  "operationSerialQueue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    internal let operationConcurrentQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name =  "operationConcurrentQueue"
        queue.maxConcurrentOperationCount = 50
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "AnyWorkerQDispatchQueue", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem, target: .global())
    private let lock = NSRecursiveLock()
    
    internal var _scenarios: [QueueManager.Scenario] = []
    internal var _observations: [NSKeyValueObservation] = []
    
    public var operations: [CompleteOperation] {
        let operations: [CompleteOperation] = (self.operationSerialQueue.operations + self.operationConcurrentQueue.operations).filter { $0.isCancelled == false && $0.isFinished == false}.map{ $0 as? CompleteOperation}.compactMap{ $0 }
        print("operations:", operations.map {$0.name ?? ""})
        return operations
    }
    
    public init() {
        let operationCountListener = self.operationSerialQueue.observe(\.operationCount, options: [.old,.new]) { object, change in
            if (change.oldValue == 0) && change.newValue == 1 {
                self.state = .working
            } else if change.oldValue ?? 0 > 0 && change.newValue == 0 {
                self.state = .resting
                self._scenarios = []
            }
        }
        _observations.append(operationCountListener)
    }
    
    func operation(by name: String) -> CompleteOperation? {
        return self.operationSerialQueue.operations.first { $0.name == name } as? CompleteOperation
    }
    
    private func isValidDurationCondition(worker: Worker) -> Bool {
        let condition = worker.duration
        let valid =  Date().timeIntervalSince1970 - self.lastExcuateOperation(by: worker.name) > condition
        return valid
    }
    
    private func isValidOperationStateCondition(worker: Worker) -> Bool {
        let valid = worker.operation.isFinished == false && worker.operation.isExecuting == false && worker.operation.isReady == true
        return valid
    }
    
    private func isValidIgnoreStateCondition(worker: Worker) -> Bool {
        let valid = self.operations.contains(where: {$0.name == worker.name}) == true && worker.ignore == false
        return valid
    }
    
    public func add(scenario: Scenario) {
        self.dispatchQueue.async {
            self.lock.lock()
            self.operationSerialQueue.isSuspended = true
            guard self._scenarios.contains(where: { scenario.name == $0.name }) == false else {
                print("\(Date()) Scenario: \(scenario.name) ignore.")
                return
            }
            
            self._scenarios.append(scenario)
            
            print("\(Date()) Scenario: \(scenario.name) begin.")
            
            for task in scenario.tasks {
                switch task {
                case .sync(let worker):
                    //print("\(Date()) Scenario: ----------- check worker:", worker.name)
                    
                    if self.isValidIgnoreStateCondition(worker: worker) == true {
                        //print("\(Date()) Scenario: ----------- check worker => ", worker.name)
                        worker.completed {
                            self.lock.lock()
                            QueueManager.lasttimeExcuteWorker[worker.name] = Date().timeIntervalSince1970
                            self.lock.unlock()
                        }
                        self.operationSerialQueue.addOperation(worker.operation)
                    }
                    
                    else if self.operations.contains(worker.operation) == false &&
                        self.isValidOperationStateCondition(worker: worker) &&
                        self.isValidIgnoreStateCondition(worker: worker) == false &&
                        self.isValidDurationCondition(worker: worker) {
                        //print("\(Date()) Scenario: ----------- check worker => ", worker.name)
                        worker.completed {
                            self.lock.lock()
                            QueueManager.lasttimeExcuteWorker[worker.name] = Date().timeIntervalSince1970
                            self.lock.unlock()
                        }
                        self.operationSerialQueue.addOperation(worker.operation)
                    }
                    
                    else {
                        print("\(Date()) Scenario: ignore => \(worker.name)")
                        worker.completedCalbacks.forEach { $0?()}
                    }
                case .async(let workers):
                    let operation = BlockOperation {
                        let _start_mearsure = CFAbsoluteTimeGetCurrent()
                        print("\(Date()) Scenario: >> async \(workers.map { $0.name}) start.")
                        
                        let _workers: [Worker] = workers.filter { worker -> Bool in
                            self.operations.contains(worker.operation) == false &&
                                self.isValidOperationStateCondition(worker: worker) &&
                                self.isValidIgnoreStateCondition(worker: worker) == false &&
                                self.isValidDurationCondition(worker: worker)
                        }
                        
                        let operations = _workers.map { $0.operation}
                        for worker in _workers {
                            worker.completed {
                                self.lock.lock()
                                QueueManager.lasttimeExcuteWorker[worker.name] = Date().timeIntervalSince1970
                                self.lock.unlock()
                            }
                            //self.lasttimeExcuteWorker[$0.name] = Date().timeIntervalSince1970
                        }
                        
                        for worker in workers {
                            if _workers.contains(where: { $0.name == worker.name}) == false {
                                print("\(Date()) Scenario: ignore => \(worker.name)")
                                worker.completedCalbacks.forEach { $0?()}
                            }
                        }
                        
                        print("\(Date()) Scenario: >> async begin with \(_workers.map { $0.name}).")
                        
                        if _workers.count > 0 {
                            self.operationConcurrentQueue.addOperations(operations, waitUntilFinished: true)
                        }
                        
                        print("\(Date()) Scenario: >> async \(_workers.map { $0.name}) done in ",  CFAbsoluteTimeGetCurrent() - _start_mearsure, "seconds")
                    }
                    
                    operation.queuePriority = .veryHigh
                    self.operationSerialQueue.addOperation(operation)
                }
            }
            self.operationSerialQueue.isSuspended = false
            self.lock.unlock()
        }
        
    }
    
}
