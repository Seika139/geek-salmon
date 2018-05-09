//
//  ViewController.swift
//  sample2
//
//  Created by 鈴木健一 on 2018/05/07.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var photoImage: UIImageView!
    var nameArray: [String] = ["仗助","承太郎","徐倫"]
    
    @IBOutlet var answerLabel : UILabel!
    
    @IBOutlet var inputTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        answerLabel.text = "ちゃま"
        inputTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func printArray(){
        print(nameArray)
    }

    @IBAction func changeImage(){
        photoImage.image = UIImage(named: "anastasia6.jpg")
    }
    // キーボードの改行が押された時に呼ばれるデリゲートメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じるコード
        textField.resignFirstResponder()
        return true
    }
}

