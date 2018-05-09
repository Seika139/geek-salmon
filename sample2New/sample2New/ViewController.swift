//
//  ViewController.swift
//  sample2New
//
//  Created by 鈴木健一 on 2018/05/09.
//  Copyright © 2018年 seika. All rights reserved.
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
    
    @IBAction func showArert() {
        // アラートの表示
        let alert = UIAlertController(title: "注意", message: "あああああああ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //OKボタンを押した時のアクション
            alert.dismiss(animated: true, completion: nil)
        }
        let canselAction = UIAlertAction(title: "cansel", style: .default) { (action) in
            //OKボタンを押した時のアクション
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(canselAction)
        self.present(alert, animated: true, completion: nil)
    }

}

