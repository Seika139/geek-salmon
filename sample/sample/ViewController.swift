//
//  ViewController.swift
//  sample
//
//  Created by 鈴木健一 on 2018/04/27.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 使用するデータの宣言
    var number: Int = 0
    // 変数の書き方
    // var 変数名: データの型 = 初期値
    
    @IBOutlet var label: UILabel!
    // IB = interfacebuilder OUtlet プログラムから命令を受け取るパーツ
    // var 変数名: データの型!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 乱数を発生させてnumberに代入
        number = Int(arc4random_uniform(10))
        label.text = String(number)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func plus() {
        number +=  1
        // labelのtext部分にstring型に変換したnumberを入れる
        label.text = String(number)
        if number == 10 {
            // 画面遷移のコード
            self.performSegue(withIdentifier: "Second", sender: nil)
        }
    }
    @IBAction func minus(){
        number += -1
        label.text = String(number)
        // UserDefaultsに保存して、値を端末内に保持
        let ud = UserDefaults.standard
        ud.set(number, forKey: "Number")
        ud.synchronize()
    }
    @IBAction func clear(){
        number = 0
        label.text = String(number)
    }
    
    // 次の画面に値を渡す関数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //値を渡すコード(次の画面のオブジェクトを取得)
        let secondViewController = segue.destination as! SecondViewController
        //次の画面の変数に代入
        secondViewController.passedNumber = number
    }
}

