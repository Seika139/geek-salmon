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
    
    var lang: Int {
        get {
            return ud.integer(forKey: "langNum")
        }
        set {
            ud.set(newValue, forKey: "langNum")
            ud.synchronize()
        }
    }
    let naviBarLB = ["Create File","ファイルを作成する","新建文件","파일을 작성하기","Crear archivo","Créer fichier"]
    let labelLB = ["Input title","タイトルを入力","输入主题","제목을 입력","Titular","Titre"]
    
    let ud = UserDefaults.standard
    var titleArray: [String] {
        get {
            if ud.array(forKey: "titleArray") == nil {
                return [String]()
            } else {
                return ud.array(forKey: "titleArray") as! [String]
            }
        }
        set {
            ud.set(newValue.self, forKey: "titleArray")
            ud.synchronize()
        }
    }
    let myOrange = UIColor(red: 246/256, green: 206/256, blue: 76/256, alpha: 1.0)
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        writeName.delegate = self
        writeName.textColor = darkOrange
        self.view.backgroundColor = myOrange
        sheetName.textColor = UIColor.white
        navigationItem.title = naviBarLB[lang]
        sheetName.text = labelLB[lang]
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
    
    @IBAction func byPerformSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "createFile", sender: nil)
    }
    
    /// セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as? MainViewController
        //現在の日付を取得
        let date: Date = Date()
        // 日付のフォ-マット
        let formatForTitle = DateFormatter()
        formatForTitle.dateFormat = "yyyy/MM/dd"
        let udFormat = DateFormatter()
        udFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //日付をStringに変換する
        let sDate = formatForTitle.string(from: date)
        let udDate = udFormat.string(from: date)
        // シートの名前の設定
        if (writeName.text?.isEmpty)! {
            ud.set(sDate, forKey: udDate + "/sheetName")
        } else {
            ud.set(writeName.text!, forKey: udDate + "/sheetName")
        }
        titleArray.append(udDate)
        next?.sheetBirthday = udDate
    }

}
