//
//  ViewController.swift
//  TextButton
//
//  Created by Tobioka on 2017/10/03.
//  Copyright © 2017年 tnantoka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// [marker1]
    @IBAction func onTap(_ sender: UIButton) {
        sender.setTitle(
            "タップされました", // 変更後のタイトル
            for: .normal     // 通常時のタイトルを変更する
        )
    }
    /// [marker1]
}

