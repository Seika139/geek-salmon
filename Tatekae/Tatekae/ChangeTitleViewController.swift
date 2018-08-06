//
//  ChangeTitleViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/06/22.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ChangeTitleViewController: UIViewController {
    
    let myRed = UIColor(red: 209/256, green: 46/256, blue: 31/256, alpha: 1.0)
    let myOrange = UIColor(red: 246/256, green: 206/256, blue: 76/256, alpha: 1.0)
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    var sheetName = UITextField()
    var saveBtn = UIButton()
    var titleText: String!
    var sheetBirthday: String!
    let lang = UserDefaults.standard.integer(forKey: "langNum")
    let sheetTitleLB = ["Rename title","タイトルを変更する","变更主题","제목을 변경","Rebautizar","Renommer le titre"]
    let backLB = ["back","戻る","返回","돌아가기","volver","revenir"]
    let saveLB = ["Save","保存","保存","저장","Guardar","Garder"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myOrange
        self.navigationItem.title = sheetTitleLB[lang]
        // 自動で設定されている戻るボタンを隠す
        self.navigationItem.hidesBackButton = true
        let leftButton = UIBarButtonItem(title: backLB[lang], style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToSheet))
        self.navigationItem.leftBarButtonItem = leftButton
        setItems()
    }
    
    func setItems() {
        // ナビゲーションコントローラーの高さ
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        
        /* sheetName */
        let sideSpace: CGFloat = UIScreen.main.nativeBounds.height == 2436 ? 50 : 15
        sheetName.frame = CGRect(x: sideSpace, y: statusBarHeight + navigationBarHeight + 30, width: self.view.frame.width - 2*sideSpace, height: 40)
        sheetName.borderStyle = .bezel
        sheetName.clearButtonMode = UITextFieldViewMode.always
        sheetName.addTarget(self, action: #selector(onTap), for: .editingDidEndOnExit)
        sheetName.text = titleText
        sheetName.returnKeyType = UIReturnKeyType.done
        sheetName.backgroundColor = UIColor.white
        sheetName.textColor = darkOrange
        view.addSubview(sheetName)
        
        /* saveBtn */
        saveBtn.frame = CGRect(x: self.view.frame.width/2 - 30, y: statusBarHeight + navigationBarHeight + 90, width: 60, height: 40)
        saveBtn.backgroundColor = UIColor.white
        saveBtn.setTitleColor(darkOrange, for: .normal)
        saveBtn.setTitle(saveLB[lang], for: .normal)
        saveBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        saveBtn.addTarget(self, action: #selector(changeTitle), for: .touchUpInside)
        view.addSubview(saveBtn)
    }
    
    @objc func onTap(sender: Any) {
        
    }
    
    @objc func changeTitle() {
        UserDefaults.standard.set(sheetName.text, forKey: sheetBirthday + "/sheetName")
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func backToSheet() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面の回転に対応
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setItems()
    }
    
}
