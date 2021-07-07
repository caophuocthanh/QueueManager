//
//  CompleteOperation.swift
//  AnyWorkerQueue
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit


public extension QueueManager {
    
    class CompleteOperation: Operation {
                
        private var makeCompleted: ((_ callback: @escaping (() -> Void)) -> Void)
        internal var completedCalback: [((() -> Void))?] = []
        
        private var start_measure_time: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        
        public override var isAsynchronous: Bool { return true }
        public override var isExecuting: Bool { return state == .executing }
        public override var isFinished: Bool {
            return state == .finished
        }
        
        var state = State.ready {
            willSet {
                willChangeValue(forKey: state.keyPath)
                willChangeValue(forKey: newValue.keyPath)
            }
            didSet {
                didChangeValue(forKey: state.keyPath)
                didChangeValue(forKey: oldValue.keyPath)
            }
        }
                
        enum State: String {
            case ready = "Ready"
            case executing = "Executing"
            case finished = "Finished"
            fileprivate var keyPath: String { return "is" + self.rawValue }
        }
        
        public override func start() {
            //print("operator: \(self.name ?? "") is start.")
            start_measure_time = CFAbsoluteTimeGetCurrent()
            if self.isCancelled {
                state = .finished
            } else {
                state = .ready
                main()
            }
        }
        
        public override func main() {
            guard self.isCancelled == false else {
                self.state = .finished
                return
            }
            
            state = .executing
            
            self.makeCompleted {
                let measure = CFAbsoluteTimeGetCurrent() - self.start_measure_time
                print("operator: \(self.name ?? "") is finish in \(measure) seconds.")
                self.state = .finished
                self.completedCalback.compactMap{ $0 }.forEach{ $0() }
            }
        }
        
        public init(name: String, makeCompleted: (@escaping (_ finish: @escaping (() -> Void)) -> Void)) {
            self.makeCompleted = makeCompleted
            super.init()
            self.name = name
        }
        
        public final func finish() {
            if isExecuting { state = .finished }
        }
        
        deinit {
            //print("operator deinit: name: \(self.name ?? "")")
        }
        
    }
}
