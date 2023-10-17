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
    
    internal static var workerHistories: [Int: CFAbsoluteTime] = [:]
    
    internal func lastExcuateOperation(by hasValue: Int) -> CFAbsoluteTime {
        return QueueManager.workerHistories[hasValue] ?? 0
    }
    
    public static func run(_ scenario: QueueManager.Scenario) {
        print("\n\n\(Date()) Scenario: \(scenario.name) run.")
        scenario.start_mearsure = CFAbsoluteTimeGetCurrent()
        QueueManager.default.add(scenario: scenario)
    }
    
    internal static let `default`: QueueManager = QueueManager()
    
    public var state:QueueManager.State = .resting {
        didSet { print("==> queue state:", self.state) }
    }
    
    internal let operationSerialQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name =  "OperationSerialQueue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .default
        return queue
    }()
    
    
    internal let operationConcurrentQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name =  "OperationConcurrentQueue"
        queue.maxConcurrentOperationCount = NSIntegerMax
        queue.qualityOfService = .default
        return queue
    }()
    
    private let dispatchQueue: DispatchQueue = DispatchQueue(
        label: "AnyWorkerQDispatchQueue",
        qos: .default,
        attributes: [],
        autoreleaseFrequency: .workItem,
        target: nil
    )
    
    private var lock: os_unfair_lock_s = os_unfair_lock_s()
    
    internal var _scenarios: [QueueManager.Scenario] = []
    
    internal var _observations: [NSKeyValueObservation] = []
    
    public var operations: [Operation] {
       let operations: [CompleteOperation] = (self.operationSerialQueue.operations + self.operationConcurrentQueue.operations).map{ $0 as? CompleteOperation}.compactMap{ $0 }
        return operations
    }
    
    public init() {
        let operationCountListener = self.operationSerialQueue.observe(\.operationCount, options: [.old,.new]) { [weak self] object, change in
            guard let self = self else { return }
            if (change.oldValue == 0) && change.newValue == 1 {
                self.state = .working
            } else if change.oldValue ?? 0 > 0 && change.newValue == 0 {
                self.state = .resting
                self._scenarios = []
                print("operationSerialQueue finish.......")
            }
        }
        _observations.append(operationCountListener)
    }
    
    func operation(by name: String) -> CompleteOperation? {
        return self.operationSerialQueue.operations.first { $0.name == name } as? CompleteOperation
    }
    
    private func isValidRateLimitCondition(worker: Worker) -> Bool {
        let condition = worker.rate_limit
        let period =  CFAbsoluteTimeGetCurrent() - self.lastExcuateOperation(by: worker.hashValue)
        let valid =  period > condition
        return valid
    }
    
    private func isValidOperationStateCondition(worker: Worker) -> Bool {
        let valid = worker.operation.isFinished == false && worker.operation.isExecuting == false && worker.operation.isReady == true
        return valid
    }
    
    private func isValidIgnoreStateCondition(worker: Worker) -> Bool {
        let valid = self.operations.contains(where: {$0.name?.hashValue == worker.name.hashValue}) == true && worker.ignore == false
        return valid
    }
    
    private func storeHistories(worker: Worker) {
        os_unfair_lock_lock(&lock)
        //print("histories:", worker.name)
        QueueManager.workerHistories[worker.hashValue] = CFAbsoluteTimeGetCurrent()
        os_unfair_lock_unlock(&lock)
    }
    
    public func add(scenario: Scenario) {
        self.dispatchQueue.sync {
            os_unfair_lock_lock(&lock)
            guard scenario.workers.contains(where: { (worker) -> Bool in
                return self.isValidRateLimitCondition(worker: worker) == true
            }) else {
                print("\(Date()) add scenario -> invaValidDuration: \(scenario.name) completed")
                scenario.completed()
                os_unfair_lock_unlock(&lock)
                return
            }
            
            if let exsit_scenario: Scenario = self._scenarios.first(where: { scenario == $0}) {
                print("\(Date()) add scenario -> exsited: \(scenario.name) just add reference start and end.")
                scenario.completed = exsit_scenario.completed
                os_unfair_lock_unlock(&lock)
                return
            }
     
            self._scenarios.append(scenario)
            
            print("\(Date()) Add scenario ->: \(scenario.name)", scenario.tasks.count)
            
            guard scenario.tasks.count > 0 else {
                scenario.completed()
                os_unfair_lock_unlock(&lock)
                return
            }
            
            
            var operations: [Operation] = []
            
            for task in scenario.tasks {
                switch task {
                case .wait(let dispatchTimeInterval):
                    let operation = CompleteOperation(name: "sleep_\(UUID().uuidString)") { [weak self] done in
                        guard let self = self else { return }
                        self.dispatchQueue.asyncAfter(deadline: .now() + dispatchTimeInterval) {
                            done(.success(nil))
                         }
                    }
                    operations.append(operation)
                case .sync(let worker):
                    //print("\(Date()) Scenario: ----------- check worker:", worker.name)
                    
                    if self.isValidIgnoreStateCondition(worker: worker) == true {
                        //print("\(Date()) Scenario: ----------- check worker => ", worker.name)
                        worker.start { [weak self] complition in
                            guard let self = self else { return }
                            self.storeHistories(worker: worker)
                        }
                        print("\(Date()) Scenario: [a] add worker \(worker.name)")
                        operations.append(worker.operation)
                    }
                    
                    else if self.operations.contains(worker.operation) == false &&
                        self.isValidOperationStateCondition(worker: worker) == true &&
                        self.isValidIgnoreStateCondition(worker: worker) == false &&
                        self.isValidRateLimitCondition(worker: worker) == true {
                        print("\(Date()) Queue add scenario_worker \(scenario.name) - worker: ", worker.name)
                        worker.start { [weak self] complition in
                            guard let self = self else { return }
                            self.storeHistories(worker: worker)
                        }
                        print("\(Date()) Scenario: [b] add worker \(worker.name)")
                        operations.append(worker.operation)
                    }
                    
                    else {
                        print("\(Date()) Scenario: ignore => \(worker.name)")
                        worker.completedCalbacks.forEach { $0?(.success(nil))}
                    }
                case .async(let name, let workers):
                    
                    let operation = CompleteOperation(name: name) {  [weak self] done in
                        guard let self = self else { return }
                        
                        let _start_mearsure = CFAbsoluteTimeGetCurrent()
                        print("\(Date()) Scenario: >> async \(workers.map { $0.name}) start.")
                        
                        let _workers: [Worker] = workers.filter { worker in
                            return self.operations.contains(worker.operation) == false &&
                                self.isValidOperationStateCondition(worker: worker) == true &&
                                self.isValidIgnoreStateCondition(worker: worker) == false &&
                                self.isValidRateLimitCondition(worker: worker) == true
                        }
 
                        for worker in workers {
                            if _workers.contains(where: { $0.name == worker.name}) == false {
                                print("\(Date()) Scenario: ignore => \(worker.name)")
                                worker.completedCalbacks.forEach { $0?(.success(nil))}
                            }
                        }
                        
                        if _workers.count > 0 {
                            print("\(Date()) Scenario: >> async begin with \(_workers.map { $0.name}).")
                            _workers.forEach { (worker) in
                                worker.start { [weak self] complition in
                                    guard let self = self else { return }
                                    self.storeHistories(worker: worker)
                                }
                            }
                            let operations = _workers.map { $0.operation}
                            self.operationConcurrentQueue.addOperations(operations, waitUntilFinished: true)
                            print("\(Date()) Scenario: >> async \(_workers.map { $0.name}) done in ",  CFAbsoluteTimeGetCurrent() - _start_mearsure, "seconds")
                            done(.success(nil))
                        } else {
                            done(.success(nil))
                        }
                    }
                    
                    operation.queuePriority = .normal
                    operation.name = name
                    operations.append(operation)
                }
            }
            
            operations.forEach { operation in
                operation.queuePriority = .normal
                operation.qualityOfService = .default
            }
            
            print(scenario.name,"run operations:", operations.map {$0.name ?? ""})
            self.operationSerialQueue.addOperations(operations, waitUntilFinished: false)
            os_unfair_lock_unlock(&lock)
        }
        
    }
    
}
