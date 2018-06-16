//
//  OpenViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/16.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toBack(){
        performSegue(withIdentifier: "open2top", sender: nil)
    }

    

}
