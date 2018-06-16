//
//  ViewController.swift
//  StopWatch
//
//  Created by 鈴木健一 on 2018/05/11.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer!
    var count: Double = 0.00
    
    @IBOutlet var timerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    @IBAction func stop() {
        timer.invalidate()
    }
    @objc func update() {
        count += 0.01
        // フォーマット指定子
        timerLabel.text = String(format: "%.2f", count)
    }
}

