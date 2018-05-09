//
//  SecondViewController.swift
//  sample
//
//  Created by 鈴木健一 on 2018/04/27.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var passedNumber: Int = 0
    @IBOutlet weak var numberLavel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ビューが表示された時に動く関数
        // ここでは渡されたpassedNumberの整数を表示する
        numberLavel.text = String(passedNumber)
        
        // UserDefaultsに"Number"キーで保持されている値を取り出す
        let ud = UserDefaults.standard
        print(ud.integer(forKey: "Number"))
    }

    @IBAction func random(){
        // 乱数を発生させてnumberに代入
        passedNumber = Int(arc4random_uniform(10))
        numberLavel.text = String(passedNumber)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        // 戻るコード
        self.dismiss(animated: true, completion: nil)
    }
    
}
