//
//  Worker.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit


public extension QueueManager {
    
    class Worker: Hashable {
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
        }
        
        public static func == (lhs: Worker, rhs: Worker) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public typealias Calback = (((Result<Any?, Error>) -> Void))
        
        internal var completedCalbacks: [Calback?] = []
        internal var startCalbacks: [Calback?] = []
        
        public func start(calback: @escaping (((Result<Any?, Error>) -> Void))) {
            self.startCalbacks.append(calback)
        }
        
        public func completed(calback: @escaping (((Result<Any?, Error>) -> Void))) {
            self.completedCalbacks.append(calback)
        }
        
        
        private var operations: [Operation] {
            return QueueManager.default.operations
        }
        
        private var handler:                    ((_ callback: @escaping ((Result<Any?, Error>) -> Void)) -> Void)
        private(set) public var name:           String
        private(set) public var rate_limit:     TimeInterval = 0
        private(set) public var ignore:         Bool = false
        private(set) public var timeout:        TimeInterval = 120
        private(set) public var retry:          Int = 0
        
        
        var queuePriority: Operation.QueuePriority {
            get { return self.operation.queuePriority}
            set {self.operation.queuePriority = newValue }
        }
        
        internal var operation: Operation {
            
            if self.ignore == false {
                let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
                    guard let self = self else { return }
                    self.retry(self.retry, task: self.handler) { [weak self] completed in
                        guard let self = self else { return }
                        switch completed {
                        case .success(let data):
                            print("worker \(self.name) success:", data ?? "nil")
                            makeCompleted(.success(data))
                        case .failure(let error):
                            print("worker \(self.name) error:", error)
                            makeCompleted(.failure(error))
                        }
                    }
                }
                _operation.queuePriority = .normal
                _operation.completedCalback += completedCalbacks
                return _operation
                
            } else {
                
                if let _operation = self.operations.first(where: { $0.name == name}) {
                    _operation.queuePriority = .normal
                    return _operation
                }
                
                //else
                let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
                    guard let self = self else { return }
                    self.retry(self.retry, task: self.handler) { [weak self] completed in
                        guard let self = self else { return }
                        switch completed {
                        case .success(let data):
                            print("worker \(self.name) success:", data ?? "nil")
                            makeCompleted(.success(data))
                        case .failure(let error):
                            print("worker \(self.name) error:", error)
                            makeCompleted(.failure(error))
                        }
                    }
                }
                _operation.queuePriority    = .normal
                _operation.startCalback     += startCalbacks
                _operation.completedCalback += completedCalbacks
                return _operation
            }
        }
        
        private func retry<T>(_ attempts: Int, task: @escaping (_ completion:@escaping (Result<T, Error>) -> Void) -> Void,  completion:@escaping (Result<T, Error>) -> Void) {
            task({ result in
                switch result {
                case .success(_):
                    completion(result)
                case .failure(let error):
                    if attempts > 0 {
                        print("\(self.name) retries left \(attempts) and error = \(error)")
                        self.retry(attempts - 1, task: task, completion: completion)
                    } else {
                        completion(result)
                    }
                }
            })
        }
        
        public init(name: String,
                    rate_limit: TimeInterval = 0,
                    ignore: Bool = false,
                    //timeout: TimeInterval = 120,
                    retry: Int = 0,
                    handler: @escaping ((_ callback: @escaping ((Result<Any?, Error>) -> Void)) -> Void)) {
            self.name       = name
            self.handler    = handler
            self.rate_limit   = rate_limit
            self.ignore     = ignore
            //self.timeout    = timeout
            self.retry      = retry
        }
        
        deinit {
            print(self.name, "worker deinit")
        }
    }
}
