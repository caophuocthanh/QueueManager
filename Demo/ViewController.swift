//
//  ViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 7/6/21.
//

import UIKit
import AnyWorkerQueue

class ViewController: UIViewController {
    
    let button1: UIButton = {
        let button = UIButton()
        button.setTitle("scenario_1", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    
    let button2: UIButton = {
        let button = UIButton()
        button.setTitle("scenario_2", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let button3: UIButton = {
        let button = UIButton()
        button.setTitle("scenario_3", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(200)-[v1(50)]-(150)-[v2(50)]-(150)-[v3(50)]", options: [], metrics: nil, views: ["v1": button1, "v2": button2, "v3": button3]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(150)]", options: [], metrics: nil, views: ["v": button1]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(150)]", options: [], metrics: nil, views: ["v": button2]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(150)]", options: [], metrics: nil, views: ["v": button3]))
        self.view.addConstraint(NSLayoutConstraint(item: self.view!, attribute: .centerX, relatedBy: .equal, toItem: self.button1, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view!, attribute: .centerX, relatedBy: .equal, toItem: self.button2, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view!, attribute: .centerX, relatedBy: .equal, toItem: self.button3, attribute: .centerX, multiplier: 1, constant: 0))
        
        button1.addTarget(self, action: #selector(button1DidTouch), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2DidTouch), for: .touchUpInside)
        button3.addTarget(self, action: #selector(button3DidTouch), for: .touchUpInside)
    }
    
    @objc func button1DidTouch() {
        button1.pulsate()
        button1.backgroundColor = .gray
        let send = self.scenario_1 {
            DispatchQueue.main.async {
                self.button1.pulsate()
                self.button1.backgroundColor = .red
            }
            print("\n\n\n😍😍😍😍😍 \(Date()) scenario_1 [tap] done")
        }
        QueueManager.run(send)
    }
    
    @objc func button2DidTouch() {
        button2.pulsate()
        button2.backgroundColor = .gray
        let send = self.scenario_2 {
            DispatchQueue.main.async {
                self.button2.pulsate()
                self.button2.backgroundColor = .blue
            }
            print("\n\n\n😍😍😍😍😍 \(Date()) scenario_2 [tap] done")
        }
        QueueManager.run(send)
    }
    
    @objc func button3DidTouch() {
        button3.pulsate()
        button3.backgroundColor = .gray
        let send = self.scenario_3 {
            DispatchQueue.main.async {
                self.button3.pulsate()
                self.button3.backgroundColor = .green
            }
            
            print("\n\n\n😍😍😍😍😍 \(Date()) scenario_3 [tap] done")
        }
        QueueManager.run(send)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        
//        
//        
//        
//        
//        
//        Workers.fetch_task1.completed {
//            print("🥉 w1 => calback")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            for i in 0...3 {
//                let send = self.scenario_1 {
//                    print("\n\n\n😍😍😍😍😍 \(Date()) scenario_1 [\(i)] done")
//                }
//                QueueManager.run(send)
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            for i in 0...5 {
//                
//                //
//                let send = self.scenario_2 {
//                    print("\n\n\n😍😍😍😍😍 \(Date()) scenario_2 [\(i)]  done")
//                }
//                QueueManager.run(send)
//                
//                let send1 = self.scenario_3 {
//                    print("\n\n\n😍😍😍😍😍 \(Date()) scenario_3 [\(i)] done")
//                }
//                QueueManager.run(send1)
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let send1 = self.scenario_1 {
//                print("\n\n\n😍😍😍😍😍 \(Date()) scenario_11 done")
//            }
//            QueueManager.run(send1)
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            let send1 = self.scenario_1 {
//                print("\n\n\n😍😍😍😍😍 \(Date()) scenario_12 done")
//            }
//            QueueManager.run(send1)
//        }
        
    }
    
    
    func scenario_1(completed: @escaping () -> Void) -> QueueManager.Scenario {
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
    
    func scenario_2(completed: @escaping () -> Void) -> QueueManager.Scenario {
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
    
    func scenario_3(completed: @escaping () -> Void) -> QueueManager.Scenario {
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

extension UIButton {

        func pulsate() {

            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.2
            pulse.fromValue = 0.98
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 2
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0

            layer.add(pulse, forKey: "pulse")
        }
}

