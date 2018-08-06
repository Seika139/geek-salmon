//
//  ViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/16.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var newButton = UIButton()
    var openButton = UIButton()
    var configButton = UIButton()
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    let myOrange = UIColor(red: 246/256, green: 206/256, blue: 76/256, alpha: 1.0)
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)
    let newLB = ["New","新規作成","新建","새로 만들기","Nuevo archivo","Nouveau fichier"]
    let openLB = ["Open","開く","打开","열기","Abrir","Ouvrir"]
    let configLB = ["Config","設定","设定","설정","Configuración","Configuration"]
    let backLB = ["back","戻る","返回","돌아가기","volver","revenir"]
    let ud = UserDefaults.standard
    let imageView: UIImageView = UIImageView(image: UIImage(named: "bgimage"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* UserDefaultsを消す時
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
         */
//        setButton()
        // navigationBarの設定
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = darkOrange
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: darkOrange
        ]
        self.view.backgroundColor = myOrange
        setImage()
    }
    
    func setImage() {
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let barHeight = navigationBarHeight + statusBarHeight
        let width:CGFloat = view.frame.size.width
        let height:CGFloat = view.frame.size.height
        var imageLength: CGFloat = 0
        if UIScreen.main.nativeBounds.height == 2436 {  // iphoneX
            if width > height {
                imageLength = height * 2/3 - barHeight - 10
                imageView.frame.size = CGSize(width: imageLength, height: imageLength)
                imageView.center = CGPoint(x: width / 2, y: height / 3)
            } else {
                imageLength = height / 2 - barHeight - 35
                imageView.frame.size = CGSize(width: imageLength, height: imageLength)
                imageView.center = CGPoint(x: width / 2, y: (height / 2 + barHeight) / 2 )
            }
        } else {
            if width > height {
                imageLength = height * 2/3 - barHeight - 10
                imageView.frame.size = CGSize(width: imageLength, height: imageLength)
                imageView.center = CGPoint(x: width / 2, y: height / 3)
            } else {
                imageLength = height / 2 - barHeight - 20
                imageView.frame.size = CGSize(width: imageLength, height: imageLength)
                imageView.center = CGPoint(x: width / 2, y: (height / 2 + barHeight) / 2 )
            }
        }
        self.view.addSubview(imageView)
    }
    
    func setButton() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        var underSpace: CGFloat = 15
        var sideSpace: CGFloat = 20
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                // iphoneX
                underSpace = 20
                sideSpace = 40
            } else {
                underSpace = 15
                sideSpace = 20
            }
        }
        let btnHeightV = (height / 2 - 80) / 3
        let btnHeightH = (height / 3) - underSpace
        let btnWidthH = (width - 20 - 2*sideSpace) / 3
        
        /* 画面の向きに応じてボタンのレイアウトを変更 */
        if height > width {
            newButton.frame = CGRect(x: 60, y: height / 2, width: width - 120, height: btnHeightV)
            openButton.frame = CGRect(x: 60, y: height / 2 + btnHeightV + 20, width: width - 120, height: btnHeightV)
            configButton.frame = CGRect(x: 60, y: height/2 + 40 + 2*btnHeightV, width: width - 120, height: btnHeightV)
        } else {
            newButton.frame = CGRect(x: sideSpace, y: height * 2/3, width: btnWidthH, height: btnHeightH)
            openButton.frame = CGRect(x: 10 + sideSpace + btnWidthH, y: height * 2/3, width: btnWidthH, height: btnHeightH)
            configButton.frame = CGRect(x: 20 + sideSpace + btnWidthH*2, y: height * 2/3 , width: btnWidthH, height: btnHeightH)
        }
        
        let lang = UserDefaults.standard.integer(forKey: "langNum")
        navigationItem.backBarButtonItem?.title = backLB[lang]
        
        /* newButton */
        newButton.setTitle(newLB[lang], for: .normal)
        newButton.titleLabel?.font =  UIFont.systemFont(ofSize: 36)
        newButton.titleLabel?.adjustsFontSizeToFitWidth = true
        newButton.addTarget(self, action: #selector(new), for: .touchUpInside)
        newButton.backgroundColor = UIColor.white
        newButton.setTitleColor(darkOrange, for: .normal)
        //newButton.titleLabel?.textColor = UIColorだとうまくいかないので注意
        
        // 角を丸くする処理
        newButton.layer.cornerRadius = 20.0 // どれくらい丸くするか
        newButton.layer.masksToBounds = true // 丸くするのを許可する
        view.addSubview(newButton)
        
        /* openButton */
        openButton.titleLabel?.font =  UIFont.systemFont(ofSize: 36)
        openButton.titleLabel?.adjustsFontSizeToFitWidth = true
        openButton.addTarget(self, action: #selector(open), for: .touchUpInside)
        openButton.setTitle(openLB[lang], for: .normal)
        openButton.setTitleColor(darkOrange, for: .normal)
        openButton.backgroundColor = UIColor.white
        openButton.layer.cornerRadius = 20.0
        openButton.layer.masksToBounds = true
        view.addSubview(openButton)
        
        /* configButton */
        configButton.titleLabel?.font =  UIFont.systemFont(ofSize: 36)
        configButton.titleLabel?.adjustsFontSizeToFitWidth = true
        configButton.addTarget(self, action: #selector(config), for: .touchUpInside)
        configButton.setTitle(configLB[lang], for: .normal)
        configButton.backgroundColor = UIColor.white
        configButton.setTitleColor(darkOrange, for: .normal)
        configButton.layer.cornerRadius = 20.0
        configButton.layer.masksToBounds = true
        view.addSubview(configButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButton()
    }
    
    // 画面の回転に対応
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.removeFromSuperview()
        setButton()
        setImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func new() {
        self.performSegue(withIdentifier: "new", sender: nil)
    }
    
    @objc func open() {
        self.performSegue(withIdentifier: "open", sender: nil)
    }
    
    @objc func config() {
        self.performSegue(withIdentifier: "config", sender: nil)
    }

    /*
     日本語
     English
     韓国語 -> 朴
     中国語 -> ほうじゅり
     スペイン語 -> セガール
     フランス語 -> ぬま
     ロシア語 ->
     イタリア語 -> 
     ドイツ語 ->
    */
    
    
}

