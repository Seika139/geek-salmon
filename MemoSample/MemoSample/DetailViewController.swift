//
//  DetailViewController.swift
//  MemoSample
//
//  Created by 鈴木健一 on 2018/05/11.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var memoTextView: UITextView!
    var selectedMemo: String!
    var selectedRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoTextView.text = selectedMemo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteMemo() {
        let ud = UserDefaults.standard
        if ud.array(forKey: "memoArray") != nil {
            var saveMemoArray = ud.array(forKey: "memoArray") as! [String]
            saveMemoArray.remove(at: selectedRow)
            ud.setValue(saveMemoArray, forKey: "memoArray")
            ud.synchronize()
            // pushの場合に画面を戻る方法
            self.navigationController?.popViewController(animated: true)
        }
    }

}
