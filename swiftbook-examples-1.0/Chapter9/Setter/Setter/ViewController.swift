//
//  ViewController.swift
//  Setter
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
        class IPhone {
            var cover = ""
            var isCovered: Bool {
                get {
                    return !cover.isEmpty
                }
                set {
                    if newValue {
                        cover = "カバー"
                    } else {
                        cover = ""
                    }
                }
            }
        }
        
        let phone = IPhone()
        phone.isCovered = true
        print(phone.cover)
        /// [marker1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

