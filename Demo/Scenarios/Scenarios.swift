//
//  Scenarios.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/26/21.
//

import Foundation
import AnyWorkerQueue

class Scenarios {
    
    static func scenario_1(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "scenario_1",
            tasks: [
                .sync(Workers.fetch_task1),
                .async([
                    Workers.fetch_task2,
                    Workers.fetch_task3,
                    Workers.fetch_task4,
                    Workers.fetch_task5,
                    Workers.fetch_task6,
                    Workers.fetch_task7,
                    Workers.fetch_task8,
                ]),
                .sync(Workers.fetch_task9),
                .sync(Workers.fetch_task10)
            ],
            completed: {
                //print("interval sync completed\n\n\n\n")
                completed()
            })
    }
    
    static func scenario_2(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "scenario_2",
            tasks: [
                .async([
                    Workers.fetch_task10,
                    Workers.fetch_task9,
                    Workers.fetch_task8,
                ]),
                .sync(Workers.push_task1),
            ],
            completed: {
                //print("first sync completed \n\n\n\n")
                completed()
            })
    }
    
    static func scenario_3(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "scenario_3",
            tasks: [
                .async([
                    Workers.fetch_task1,
                    Workers.fetch_task2,
                    Workers.fetch_task11,
                ]),
                .sync(Workers.push_task2)
            ],
            completed: {
                //print("first sync completed \n\n\n\n")
                completed()
            })
    }

}
