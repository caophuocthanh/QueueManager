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
        print("🥰🥰🥰 tap scenario_1")
        button1.pulsate()
        button1.backgroundColor = .gray
        let send = Scenarios.scenario_1 { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.button1.pulsate()
                self.button1.backgroundColor = .red
            }
            print("\n\n\n😍😍😍😍😍 \(Date()) scenario_1 [tap] done")
        }
        QueueManager.run(send)
    }
    
    @objc func button2DidTouch() {
        print("🥰🥰🥰 tap scenario_2")
        button2.pulsate()
        button2.backgroundColor = .gray
        let send = Scenarios.scenario_2 { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.button2.pulsate()
                self.button2.backgroundColor = .blue
            }
            print("\n\n\n😍😍😍😍😍 \(Date()) scenario_2 [tap] done")
        }
        QueueManager.run(send)
    }
    
    @objc func button3DidTouch() {
        print("🥰🥰🥰 tap scenario_3")
        button3.pulsate()
        button3.backgroundColor = .gray
        let send = Scenarios.scenario_3 { [weak self] in
            guard let self = self else { return }
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
        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
//            print("interval button1")
//            self.button1.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
//            let send = Scenarios.scenario_1 {
//                DispatchQueue.main.async {
//                    self.button1.pulsate()
//                    self.button1.backgroundColor = .red
//                }
//                print("\n\n\n😍😍😍😍😍 \(Date()) scenario_1 [interval] done")
//            }
//            QueueManager.run(send)
//        }
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
//            print("interval button2")
//            self.button2.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
//            let send = Scenarios.scenario_2 {
//                DispatchQueue.main.async {
//                    self.button2.pulsate()
//                    self.button2.backgroundColor = .blue
//                }
//                print("\n\n\n😍😍😍😍😍 \(Date()) scenario_2 [interval] done")
//            }
//            QueueManager.run(send)
//        }
                
    }
    
    
   
    
    
}

extension UIButton {

        func pulsate() {

//            let pulse = CASpringAnimation(keyPath: "transform.scale")
//            pulse.duration = 0.2
//            pulse.fromValue = 0.98
//            pulse.toValue = 1.0
//            pulse.autoreverses = true
//            pulse.repeatCount = 2
//            pulse.initialVelocity = 0.5
//            pulse.damping = 1.0
//
//            layer.add(pulse, forKey: "pulse")
        }
}

