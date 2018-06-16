//
//  ViewController.swift
//  Union
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
        let rooms1: Set = [101, 102, 103, 104]    // 1階の部屋番号
        let rooms2: Set = [201, 202, 203, 204]    // 2階の部屋番号
        
        print(rooms1.union(rooms2))
        /// [marker1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

