//
//  AddMemoViewController.swift
//  MemoSample
//
//  Created by 鈴木健一 on 2018/05/11.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class AddMemoViewController: UIViewController {
    
    @IBOutlet var memoTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        let inputTxet = memoTextView.text
        let ud = UserDefaults.standard
        if ud.array(forKey: "memoArray") != nil {
            var saveMemoArray = ud.array(forKey: "memoArray") as! [String]
            if inputTxet != nil {
                saveMemoArray.append(inputTxet!)
            } else {
                print("何も入力されていません")
            }
            ud.set(saveMemoArray, forKey: "memoArray")
        } else {
            var newMemoArray = [String]()
            if inputTxet != nil {
                newMemoArray.append(inputTxet!)
            } else {
                print("何も入力されていません")
            }
            ud.set(newMemoArray, forKey: "memoArray")
        }
        ud.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
}
