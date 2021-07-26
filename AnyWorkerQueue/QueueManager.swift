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
    
    internal static var workerHistories: [String: CFAbsoluteTime] = [:]
    
    internal func lastExcuateOperation(by name: String) -> CFAbsoluteTime {
        return QueueManager.workerHistories[name] ?? 0
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
    
    internal var _scenarios: [QueueManager.Scenario] = [] {
        didSet {
            print("_scenarios:", _scenarios.map { $0.name })
        }
    }
    internal var _observations: [NSKeyValueObservation] = []
    
    public var operations: [CompleteOperation] {
        //lock.lock()
        let operations: [CompleteOperation] = (self.operationSerialQueue.operations + self.operationConcurrentQueue.operations).map{ $0 as? CompleteOperation}.compactMap{ $0 }
        //let names = operations.map {$0.name ?? ""}
        //print("operations:", names)
        //lock.unlock()
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
        let period =  CFAbsoluteTimeGetCurrent() - self.lastExcuateOperation(by: worker.name)
        let valid =  period > condition
        //print("Condition - isValidDurationCondition:", period, "valid: ",valid)
        return valid
    }
    
    private func isValidOperationStateCondition(worker: Worker) -> Bool {
        let valid = worker.operation.isFinished == false && worker.operation.isExecuting == false && worker.operation.isReady == true
        //print("Condition - isValidOperationStateCondition:", worker.operation.isFinished, worker.operation.isExecuting, worker.operation.isReady, "valid: ", valid)
        return valid
    }
    
    private func isValidIgnoreStateCondition(worker: Worker) -> Bool {
        let valid = self.operations.contains(where: {$0.name == worker.name}) == true && worker.ignore == false
        //print("Condition - isValidIgnoreStateCondition:", "valid: ",valid)
        return valid
    }
    
    private func storeHistories(worker: Worker) {
        self.lock.lock()
        print("histories:", worker.name)
        QueueManager.workerHistories[worker.name] = CFAbsoluteTimeGetCurrent()
        self.lock.unlock()
    }
    
    public func add(scenario: Scenario) {
        self.dispatchQueue.sync {
            self.lock.lock()
            
            
            guard scenario.workers.contains(where: { (worker) -> Bool in
                return self.isValidDurationCondition(worker: worker) == true
            }) else {
                print("\(Date()) add scenario -> invaValidDuration: \(scenario.name) completed")
                scenario.completed()
                self.lock.unlock()
                return
            }
            
            if let exsit_scenario: Scenario = self._scenarios.first(where: { scenario == $0}) {
                print("\(Date()) add scenario -> exsited: \(scenario.name) just add reference start and end.")
                scenario.completed = exsit_scenario.completed
                self.lock.unlock()
                return
            }

     
            self._scenarios.append(scenario)
            
            print("\(Date()) add scenario ->: \(scenario.name)")
            
            for task in scenario.tasks {
                switch task {
                case .sync(let worker):
                    //print("\(Date()) Scenario: ----------- check worker:", worker.name)
                    
                    if self.isValidIgnoreStateCondition(worker: worker) == true {
                        //print("\(Date()) Scenario: ----------- check worker => ", worker.name)
                        worker.start { [weak self] in
                            guard let self = self else { return }
                            self.storeHistories(worker: worker)
                        }
                        self.operationSerialQueue.addOperation(worker.operation)
                    }
                    
                    else if self.operations.contains(worker.operation) == false &&
                        self.isValidOperationStateCondition(worker: worker) == true &&
                        self.isValidIgnoreStateCondition(worker: worker) == false &&
                        self.isValidDurationCondition(worker: worker) == true {
                        print("\(Date()) Queue add scenario_worker \(scenario.name) - worker: ", worker.name)
                        worker.start { [weak self] in
                            guard let self = self else { return }
                            self.storeHistories(worker: worker)
                        }
                        self.operationSerialQueue.addOperation(worker.operation)
                    }
                    
                    else {
                        print("\(Date()) Scenario: ignore => \(worker.name)")
                        worker.completedCalbacks.forEach { $0?()}
                    }
                case .async(let workers):
                    let operation = BlockOperation {  [weak self] in
                        guard let self = self else { return }
                        let _start_mearsure = CFAbsoluteTimeGetCurrent()
                        print("\(Date()) Scenario: >> async \(workers.map { $0.name}) start.")
                        
                        let _workers: [Worker] = workers.filter { worker in
                            return self.operations.contains(worker.operation) == false &&
                                self.isValidOperationStateCondition(worker: worker) == true &&
                                self.isValidIgnoreStateCondition(worker: worker) == false &&
                                self.isValidDurationCondition(worker: worker) == true
                        }
 
                        for worker in workers {
                            if _workers.contains(where: { $0.name == worker.name}) == false {
                                print("\(Date()) Scenario: ignore => \(worker.name)")
                                worker.completedCalbacks.forEach { $0?()}
                            }
                        }
                        
                        if _workers.count > 0 {
                            print("\(Date()) Scenario: >> async begin with \(_workers.map { $0.name}).")
                            _workers.forEach { (worker) in
                                worker.start { [weak self] in
                                    guard let self = self else { return }
                                    self.storeHistories(worker: worker)
                                }
                            }
                            let operations = _workers.map { $0.operation}
                            self.operationConcurrentQueue.addOperations(operations, waitUntilFinished: true)
                            print("\(Date()) Scenario: >> async \(_workers.map { $0.name}) done in ",  CFAbsoluteTimeGetCurrent() - _start_mearsure, "seconds")
                        }
                    }
                    
                    operation.queuePriority = .veryHigh
                    self.operationSerialQueue.addOperation(operation)
                }
            }
            self.lock.unlock()
        }
        
    }
    
}
