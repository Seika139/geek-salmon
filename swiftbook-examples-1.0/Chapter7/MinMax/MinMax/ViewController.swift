//
//  ViewController.swift
//  MinMax
//
//  Created by Tatsuya Tobioka on 2017/11/29.
//  Copyright © 2017 tnantoka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /// [marker1]
        let integers: Set = [1, 2, 3]
        let empty: Set<Int> = []
        
        print(integers.min())
        print(integers.max())
        print(empty.min())
        print(empty.max())
        /// [marker1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

