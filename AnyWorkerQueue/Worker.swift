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
        
        public typealias Calback = ((() -> Void))
        
        internal var completedCalbacks: [Calback?] = []
        internal var startCalbacks: [Calback?] = []
        
        public func start(calback: @escaping ((() -> Void))) {
            self.startCalbacks.append(calback)
        }
        public func completed(calback: @escaping ((() -> Void))) {
            self.completedCalbacks.append(calback)
        }
        
        
        private var operations: [Operation] {
            return QueueManager.default.operations
        }
        
        private var handler: ((_ callback: @escaping (() -> Void)) -> Void)
        
        public let name: String
        public var operation: Operation {
            
            if self.ignore == false {
                let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
                    guard let self = self else { return }
                    self.handler {
                        makeCompleted()
                    }
                }
                _operation.queuePriority = .normal
                _operation.completedCalback += completedCalbacks
                return _operation
            }
            
            if let _operation = self.operations.first(where: { $0.name == name}) {
                _operation.queuePriority = .normal
                return _operation
            }
            
            //else
            let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
                guard let self = self else { return }
                self.handler {
                    makeCompleted()
                }
            }
            _operation.queuePriority = .normal
            _operation.startCalback += startCalbacks
            _operation.completedCalback += completedCalbacks
            return _operation
        }
        
        public var duration: Double = 0
        public var ignore: Bool = false
        //    public var timeout: Double = 120
        //    public var retry: Int = 0
        
        public init(name: String, handler: @escaping ((_ callback: @escaping (() -> Void)) -> Void)) {
            self.name = name
            self.handler = handler
        }
        
        deinit {
            print(self.name, "worker deinit")
        }
    }
}
