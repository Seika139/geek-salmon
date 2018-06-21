//
//  ViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/16.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var NewButton: UIButton!
    @IBOutlet var OpenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* UserDefaultsを消す時
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
}

