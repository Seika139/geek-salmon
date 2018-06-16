//
//  NewViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/17.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var sheetName: UILabel!
    @IBOutlet var addMenber: UILabel!
    @IBOutlet var writeName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 忘れずに
        writeName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // キーボードの完了キーが押された時に呼ばれる関数
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じるコード
        textField.resignFirstResponder()
        return true
    }

}
