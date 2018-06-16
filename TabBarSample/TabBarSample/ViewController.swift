//
//  ViewController.swift
//  TabBarSample
//
//  Created by 鈴木健一 on 2018/05/11.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showhud(){
        SVProgressHUD.show(withStatus:"now loading")
    }

    @IBAction func dismisshud(){
        SVProgressHUD.dismiss()
    }
}

