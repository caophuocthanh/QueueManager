//
//  Worker.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit



public class Worker {
  
    public typealias Calback = ((() -> Void))
    
    internal var completedCalbacks: [Calback?] = []
    internal var startCalbacks: [Calback?] = []
    
    public func start(calback: @escaping ((() -> Void))) {
        self.startCalbacks.append(calback)
    }
    public func completed(calback: @escaping ((() -> Void))) {
        self.completedCalbacks.append(calback)
    }
    
    
    private var operations: [QueueManager.CompleteOperation] {
        return QueueManager.default.operations
    }
    
    private var handler: ((_ callback: @escaping (() -> Void)) -> Void)
    
    public let name: String
    public var operation: QueueManager.CompleteOperation {
        
        if self.ignore == false {
            let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
                guard let self = self else { return }
                self.handler {
                    makeCompleted()
                }
            }
            _operation.queuePriority = self.queuePriority
            _operation.completedCalback += completedCalbacks
            return _operation
        }
        
        if let _operation = self.operations.first(where: { $0.name == name}) {
            _operation.queuePriority = self.queuePriority
            return _operation
        }
        
        //else
        let _operation = QueueManager.CompleteOperation(name: name) { [weak self] (makeCompleted) in
            guard let self = self else { return }
            self.handler {
                makeCompleted()
            }
        }
        _operation.queuePriority = self.queuePriority
        _operation.startCalback += startCalbacks
        _operation.completedCalback += completedCalbacks
        return _operation
    }
    
    public var duration: Double = 0
    public var ignore: Bool = false
    public var timeout: Double = 120
    public var retry: Int = 0
    
    private var queuePriority: Operation.QueuePriority = .veryHigh
    
    public init(name: String, handler: @escaping ((_ callback: @escaping (() -> Void)) -> Void)) {
        self.name = name
        self.handler = handler
    }
}
