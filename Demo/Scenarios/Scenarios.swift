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
                .async("scenario_1_group_1", [
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
                completed()
            })
    }
    
    static func scenario_2(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "scenario_2",
            tasks: [
                .sync(Workers.fetch_task1),
                .sync(Workers.fetch_task2),
                .sync(Workers.fetch_task3),
                .sync(Workers.fetch_task4),
                .wait(.seconds(10)),
                .async("scenario_2_group_1", [
                    Workers.fetch_task5,
                    Workers.fetch_task6,
                    Workers.fetch_task7,
                    Workers.fetch_task8,
                ]),
                .wait(.seconds(2)),
                .sync(Workers.fetch_task9),
                .sync(Workers.fetch_task10),
            ],
            completed: {
                completed()
            })
    }
    
    static func scenario_3(completed: @escaping () -> Void) -> QueueManager.Scenario {
        return QueueManager.Scenario(
            name: "scenario_3",
            tasks: [
                .async("scenario_3_group_1", [
                    Workers.fetch_task1,
                    Workers.fetch_task2,
                    Workers.fetch_task4,
                    Workers.fetch_task11,
                ]),
                .sync(Workers.push_task2)
            ],
            completed: {
                completed()
            })
    }
    
}
