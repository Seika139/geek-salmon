//
//  MainViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/06/19.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate{
    
    let myBlue = UIColor(red: 26/256, green: 104/256, blue: 177/256, alpha: 1.0)
    let lightOrange = UIColor(red: 249/256, green: 225/256, blue: 147/256, alpha: 1.0)
    let myOrange = UIColor(red: 246/256, green: 206/256, blue: 76/256, alpha: 1.0)
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)
    let myRed = UIColor(red: 209/256, green: 46/256, blue: 31/256, alpha: 1.0)
    // ビューとボタンの設定
    var scrollView: UIScrollView!
    var collectionView: UICollectionView!
    var guardView: UIView!
    var optionButton = UIButton()
    var resetButton = UIButton()
    var calculateButton = UIButton()
    let numberToolbar: UIToolbar = UIToolbar()
    let rowLabel = UILabel()
    let columnLabel = UILabel()
    
    let setRows = UIStepper()
    let setColumns = UIStepper()
    
    var optionPicker = UIPickerView()
    let optionPickerHeight: CGFloat = 120
    var pickerToolbar: UIToolbar = UIToolbar()
    let pickerToolbarHeight: CGFloat = 40
    var guardViewHeight: CGFloat = 80
    var keyboardHeight: CGFloat = 0
    
    let ud = UserDefaults.standard
    var lang = UserDefaults.standard.integer(forKey: "langNum")
    let memberLB = ["Member","メンバー","成员","멤버","Miembros","Membres"]
    let resultLB = ["get or Pay","収支","收支","수지","pagar o recibir","recettes"]
    let totalLB = ["subtotal","小計","小计","소계","total parcial","total partiel"]
    let options = ["+○○○円","-○○○円","+○○%","-○○%"]
    let optionLB = ["Option","オプション","选项","옵션","Opción","Option"]
    let saveLB = ["Save","保存","保存","저장","Guardar","Garder"]
    let rowlB = ["row","行","行","핸","filas","rangée"]
    let columnLB = ["member","人数","人数","인원수","miembros","membres"]
    let alertTitle = ["Reset","リセット","重置","리셋","Reiniciar","Réinitialiser"]
    let alertMessage = ["Registration on this File will be all cleared.",
                        "今までの入力が全て消されます。",
                        "删除所有数据",
                        "지금까지 입력한게 전부 없어집니다",
                        "¿Borras todos los datos de este archivo?",
                        "Tous les données vont supprimées."]
    let OKLB = ["OK","OK","OK","확인","Sí","Oui"]
    let cancelLB = ["Cancel","キャンセル","取消","취소","Cancelar","Annuler"]
    let numberAlertTitle = ["Attention","注意","注意","주의","¡Atención!","Attention"]
    let numberAlertMessage = ["Only numerics are allowed.",
                              "入力できるのは整数値のみです。",
                              "只能输入整数",
                              "입력할수있는거는 정수뿐입니다",
                              "Tu puedes poner solo números enteros.",
                              "Seulement nombre est accepté."]

    // NewViewControllerから受け取る
    var sheetBirthday: String = ""
    var sheetName: String {
        get {
            return ud.string(forKey: sheetBirthday + "/sheetName")!
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/sheetName")
            ud.synchronize()
        }
    }
    
    // 情報の保存
    var selectedOption: Int {
        get {
            return ud.integer(forKey: sheetBirthday + "/selectedOption")
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/selectedOption")
            ud.synchronize()
        }
    }
    
    var memberArray: [String] {
        get {
            return ud.array(forKey: sheetBirthday + "/member") as! [String]
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/member")
            ud.synchronize()
        }
    }
    
    var expenditure: [[Int]] {
        get {
            return ud.array(forKey: sheetBirthday + "/expenditure") as! [[Int]]
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/expenditure")
            ud.synchronize()
        }
    }
    
    var totalArray: [Int] {
        get {
            return ud.array(forKey: sheetBirthday + "/total") as! [Int]
        }
        set {
            ud.set(newValue.self, forKey: sheetBirthday + "/total")
            ud.synchronize()
        }
    }
    
    var resultArray: [Int] {
        get {
            return ud.array(forKey: sheetBirthday + "/result") as! [Int]
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/result")
            ud.synchronize()
        }
    }
    
    var optionArray: [[Int]] {
        get {
            return ud.array(forKey: sheetBirthday + "/option") as! [[Int]]
        }
        set {
            ud.set(newValue, forKey: sheetBirthday + "/option")
            ud.synchronize()
        }
    }
    
    // よく使う関数
    
    // optionの計算を追加する　//
    func calcurateResult() {
        for i in 0..<totalArray.count {
            totalArray[i] = expenditure[i].reduce(0){$0 + $1}
        }
        let sum = Double(totalArray.reduce(0){$0+$1})
        let opSum = Double(optionArray[selectedOption].reduce(0){$0+$1})
        let num = Double(totalArray.count)
        for i in 0..<resultArray.count {
            let t = Double(totalArray[i])
            let o = Double(optionArray[selectedOption][i])
            switch(selectedOption) {
            case 0:
                resultArray[i] = Int(round(t - (sum - opSum)/num - o ))
            case 1:
                resultArray[i] = Int(round(t - (sum + opSum)/num + o ))
            case 2:
                resultArray[i] = Int(round(t - sum/(num+opSum/100) * (1+o/100)))
            default:
                resultArray[i] = Int(round(t - sum/(num-opSum/100) * (1-o/100)))
            }
        }
    }
    
    func setValues() {
        if ud.array(forKey: sheetBirthday + "/member") == nil {
            memberArray = ["","","",""]
        }
        if ud.array(forKey: sheetBirthday + "/result") == nil {
            resultArray = [0,0,0,0]
        }
        if ud.array(forKey: sheetBirthday + "/total") == nil {
            totalArray = [0,0,0,0]
        }
        if ud.array(forKey: sheetBirthday + "/expenditure") == nil {
            expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
        }
        if ud.array(forKey: sheetBirthday + "/option") == nil {
            optionArray = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        }
        calcurateResult()
    }
    
    func loadViews() {
        /* navigationController の高さ (6/19) */
        // navigationViewの高さはviewDidLoad内で書く
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        self.navigationItem.title = sheetName
        // 自動で設定されている戻るボタンを隠す
        self.navigationItem.hidesBackButton = true
        // カスタムのナビゲーションボタンを作成
        let rightButton = UIBarButtonItem(title: saveLB[lang], style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveSheet))
        self.navigationItem.rightBarButtonItem = rightButton
        // 設定ボタン(6/22)
        let leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(changeTitle))
        self.navigationItem.leftBarButtonItem = leftButton
        
        /* scrollView */
        // ScreenSizeの取得
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let screenWidth: CGFloat = view.frame.size.width
        let screenHeight: CGFloat = view.frame.size.height
        let yStart: CGFloat = navigationBarHeight + statusBarHeight
        let xStart: CGFloat = UIScreen.main.nativeBounds.height == 2436 && screenWidth > screenHeight ? 44 : 0
        if UIScreen.main.nativeBounds.height == 2436 {
            guardViewHeight = screenHeight > screenWidth ? 95 : 65
        } else {
            guardViewHeight = screenHeight > screenWidth ? screenWidth > 440 ? 65 : 80 : 55
        }
        // scrollViewを設置する座標
        let rectSize = CGRect(x: xStart, y: yStart, width: screenWidth - 2 * xStart, height: screenHeight - guardViewHeight)
        scrollView = UIScrollView(frame: rectSize)
        // 背景色の設定 ****ここの色を設定しないと背景に表が出てくる****
        scrollView.backgroundColor = myOrange
        // 親のビューにサブビュー(scrollView)を追加
        self.view.addSubview(scrollView)
        
        /* layout */
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        // scrollViewの大きさ と Cell一つ一つの大きさ
        let UIArea = UIScreen.main.nativeBounds.height * UIScreen.main.nativeBounds.width
        if UIArea >= 3*pow(10, 6) {
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 121, height: (expenditure[0].count + 4) * 60)
            layout.itemSize =  CGSize(width: 120, height: 45)
        } else if UIArea >= 1.2*pow(10, 6) {
            layout.itemSize = CGSize(width:80, height:30)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81, height: (expenditure[0].count + 4) * 40)
        } else {
            layout.itemSize = CGSize(width: 60, height: 90/4)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 61, height: (expenditure[0].count + 4) * 30)
        }
        layout.minimumInteritemSpacing = 0.1 // セルの横の隙間
        layout.minimumLineSpacing = 0 // セルの縦の隙間
        // CollectionViewを生成.
        collectionView = UICollectionView(frame: self.scrollView.frame, collectionViewLayout: layout)
        print(self.scrollView.frame)
        
        // Screen Size の取得
        let scrollScreenWidth:CGFloat = scrollView.contentSize.width
        let scrollScreenHeight:CGFloat = scrollView.contentSize.height
        collectionView.frame = CGRect(x:0, y:0, width:scrollScreenWidth, height:scrollScreenHeight)
        
        // Cellに使われるクラスを登録.
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.scrollView.addSubview(collectionView)
        
        /* guardView */
        guardView = UIView(frame: CGRect(x: 0, y: screenHeight - guardViewHeight, width: screenWidth, height: guardViewHeight))
        guardView.backgroundColor = darkOrange
        view.addSubview(guardView)
        
        //pickerView
        let height = self.view.frame.height
        let width = self.view.frame.width
        optionPicker = UIPickerView(frame:CGRect(x: 0, y: height + pickerToolbarHeight, width: width, height: optionPickerHeight))
        optionPicker.dataSource = self
        optionPicker.delegate = self
        optionPicker.backgroundColor = darkOrange
        optionPicker.selectRow(selectedOption, inComponent: 0, animated: true)
        self.view.addSubview(optionPicker)
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame:CGRect(x: 0, y: height, width: width, height: pickerToolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped))
        pickerToolbar.items = [flexible,doneBtn]
        pickerToolbar.tintColor = myRed
        self.view.addSubview(pickerToolbar)
    }
    
    func setButtons() {
        // 画面の大きさと向きによってボタンの配置を調節
        let width: CGFloat = view.frame.size.width
        let height: CGFloat = view.frame.size.height
        let btnWidth = UIScreen.main.nativeBounds.height == 2436 ? height > width ? (width - 255) / 3 : (width/2 - 50) / 3 : (width/2 - 40) / 3
        if UIScreen.main.nativeBounds.height == 2436 {
            if height > width {
                setRows.frame = CGRect(x: 10, y: height - 74, width: 94, height: 29)
                setColumns.frame = CGRect(x: 119, y: height - 74, width: 94, height: 29)
                rowLabel.frame = CGRect(x: 10, y: height - 40, width: 94, height: 20)
                columnLabel.frame = CGRect(x: 119, y: height - 40, width: 94, height: 20)
                calculateButton.frame = CGRect(x: 225, y: height - 65, width: btnWidth, height: 35)
                optionButton.frame = CGRect(x: 235 + btnWidth, y: height - 85, width: 2*btnWidth, height: 30)
                resetButton.frame = CGRect(x: 235 + btnWidth, y: height - 45, width: 2*btnWidth, height: 30)
                rowLabel.textAlignment = .center
                columnLabel.textAlignment = .center
            } else {
                let labelWidth = width/4 - 115
                setRows.frame = CGRect(x: 15 + labelWidth, y: height - 52, width: 94, height: 29)
                setColumns.frame = CGRect(x: width/4 + labelWidth + 11, y: height - 52, width: 94, height: 29)
                rowLabel.frame = CGRect(x: 10, y: height - 52, width: labelWidth, height: 29)
                columnLabel.frame = CGRect(x: width/4 + 6, y: height - 52, width: labelWidth, height: 29)
                calculateButton.frame = CGRect(x: width / 2 + 10, y: height - 55, width: btnWidth, height: 35)
                resetButton.frame = CGRect(x: width/2 + 20 + btnWidth, y: height - 55, width: btnWidth, height: 35)
                optionButton.frame = CGRect(x: width/2 + 30 + 2*btnWidth, y: height - 55, width: btnWidth, height: 35)
                rowLabel.textAlignment = .right
                columnLabel.textAlignment = .right
            }
        } else {
            if height > width {
                if width > 440 {
                    setRows.frame = CGRect(x: 10, y: height - 59, width: 94, height: 29)
                    setColumns.frame = CGRect(x: 119, y: height - 59, width: 94, height: 29)
                    rowLabel.frame = CGRect(x: 10, y: height - 25, width: 94, height: 20)
                    columnLabel.frame = CGRect(x: 119, y: height - 25, width: 94, height: 20)
                    calculateButton.frame = CGRect(x: width / 2 + 10, y: height - 50, width: btnWidth, height: 35)
                    optionButton.frame = CGRect(x: width/2 + 20 + btnWidth, y: height - 50, width: btnWidth, height: 35)
                    resetButton.frame = CGRect(x: width/2 + 30 + 2*btnWidth, y: height - 50, width: btnWidth, height: 35)
                    rowLabel.textAlignment = .center
                    columnLabel.textAlignment = .center
                } else {
                    let labelWidth = width/2 - 110
                    setRows.frame = CGRect(x: width/2 - 94, y: height - 74, width: 94, height: 29)
                    setColumns.frame = CGRect(x: width/2 - 94, y: height - 35, width: 94, height: 29)
                    rowLabel.frame = CGRect(x: 10, y: height - 74, width: labelWidth, height: 29)
                    columnLabel.frame = CGRect(x: 10, y: height - 35, width: labelWidth, height: 29)
                    calculateButton.frame = CGRect(x: 5/9 * width, y: height - 65, width: width/6, height: 50)
                    optionButton.frame = CGRect(x: 7/9 * width, y: height - 74, width: width/6, height: 29)
                    resetButton.frame = CGRect(x: 7/9 * width, y: height - 35, width: width/6, height: 29)
                    rowLabel.textAlignment = .right
                    columnLabel.textAlignment = .right
                }
            } else {
                let labelWidth = width/4 - 115
                setRows.frame = CGRect(x: 15 + labelWidth, y: height - 42, width: 94, height: 29)
                setColumns.frame = CGRect(x: width/4 + labelWidth + 11, y: height - 42, width: 94, height: 29)
                rowLabel.frame = CGRect(x: 10, y: height - 42, width: labelWidth, height: 29)
                columnLabel.frame = CGRect(x: width/4 + 6, y: height - 42, width: labelWidth, height: 29)
                calculateButton.frame = CGRect(x: width / 2 + 10, y: height - 45, width: btnWidth, height: 35)
                resetButton.frame = CGRect(x: width/2 + 20 + btnWidth, y: height - 45, width: btnWidth, height: 35)
                optionButton.frame = CGRect(x: width/2 + 30 + 2*btnWidth, y: height - 45, width: btnWidth, height: 35)
                rowLabel.textAlignment = .right
                columnLabel.textAlignment = .right
            }
        }
        
        /* setRows */
        view.addSubview(setRows)
        setRows.addTarget(self, action: #selector(onChangeRows), for: .valueChanged)
        setRows.autorepeat = false
        setRows.minimumValue = 2
        setRows.value = Double(expenditure[0].count)
        setRows.tintColor = UIColor.white
        
        /* setColumns */
        view.addSubview(setColumns)
        setColumns.addTarget(self, action: #selector(onChangeColumns), for: .valueChanged)
        setColumns.autorepeat = false
        setColumns.minimumValue = 2
        setColumns.value = Double(expenditure.count + 1)
        setColumns.tintColor = UIColor.white
        
        /* rowLabel & columnLabel */
        rowLabel.text = rowlB[lang]
        rowLabel.textColor = UIColor.white
        columnLabel.text = columnLB[lang]
        columnLabel.textColor = UIColor.white
        rowLabel.adjustsFontSizeToFitWidth = true
        columnLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(rowLabel)
        view.addSubview(columnLabel)
        
        /* calculateButton */
        //        calculateButton.backgroundColor = UIColor.clear
        //        calculateButton.layer.borderColor = UIColor.white.cgColor
        //        calculateButton.layer.borderWidth = 0.8
        //        calculateButton.setTitle("Calculate", for: .normal)
        //        calculateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        calculateButton.addTarget(self, action: #selector(self.caluculation), for: .touchUpInside)
        //        calculateButton.layer.cornerRadius = 5.0
        //        calculateButton.layer.masksToBounds = true
        let calcImg: UIImage = UIImage(named: "calculator_icon")!
        calculateButton.setImage(calcImg, for: .normal)
        calculateButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(calculateButton)
        
        /* resetButton */
        resetButton.backgroundColor = UIColor.clear
        resetButton.layer.borderColor = UIColor.white.cgColor
        resetButton.layer.borderWidth = 0.8
        resetButton.setTitle(alertTitle[lang], for: .normal)
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetButton.addTarget(self, action: #selector(self.reset(sender: )), for: .touchUpInside)
        resetButton.layer.cornerRadius = 5.0
        resetButton.layer.masksToBounds = true
        view.addSubview(resetButton)
        
        /* optioButton */
        optionButton.backgroundColor = UIColor.clear
        optionButton.layer.borderColor = UIColor.white.cgColor
        optionButton.layer.borderWidth = 0.8
        optionButton.setTitle(optionLB[lang], for: .normal)
        optionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        optionButton.addTarget(self, action: #selector(self.selectOptions), for: .touchUpInside)
        optionButton.layer.cornerRadius = 5.0
        optionButton.layer.masksToBounds = true
        view.addSubview(optionButton)
    }
    
    @objc func onTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func reset(sender:Any) {
        let alert = UIAlertController(title: alertTitle[lang], message: alertMessage[lang], preferredStyle: .alert)
        alert.view.tintColor = myRed
        alert.addAction(UIAlertAction(title: cancelLB[lang], style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: OKLB[lang], style: .default, handler: { action in
            self.memberArray = ["","","",""]
            self.resultArray = [0,0,0,0]
            self.totalArray = [0,0,0,0]
            self.expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
            self.optionArray = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
            self.setRows.value = Double(self.expenditure[0].count)
            self.setColumns.value = Double(self.expenditure.count + 1)
            self.guardView.removeFromSuperview()
            self.collectionView.removeFromSuperview()
            self.scrollView.removeFromSuperview()
            self.setValues()
            self.loadViews()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onChangeRows(sender: UIStepper) {
        self.view.endEditing(true)
        if Int(setRows.value) > expenditure[0].count {
            for i in 0..<expenditure.count {
                expenditure[i].append(0)
            }
        } else if Int(setRows.value) < expenditure[0].count {
            for i in 0..<expenditure.count {
                expenditure[i].removeLast()
            }
        }
        let layout = UICollectionViewFlowLayout()
        let UIArea = UIScreen.main.nativeBounds.height * UIScreen.main.nativeBounds.width
        if UIArea >= 3*pow(10, 6) {
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 121, height: (expenditure[0].count + 4) * 60)
            layout.itemSize =  CGSize(width: 120, height: 45)
        } else if UIArea >= 1.2*pow(10, 6) {
            layout.itemSize = CGSize(width:80, height:30)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81, height: (expenditure[0].count + 4) * 40)
        } else {
            layout.itemSize = CGSize(width: 60, height: 90/4)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 61, height: (expenditure[0].count + 4) * 30)
        }
        resetAll()
    }
    
    @objc func onChangeColumns(sender: UIStepper) {
        self.view.endEditing(true)
        if Int(setColumns.value) > expenditure.count + 1 {
            memberArray.append("")
            resultArray.append(0)
            totalArray.append(0)
            expenditure.append([Int](repeating: 0, count: expenditure[0].count))
            for i in 0..<optionArray.count {
                optionArray[i].append(0)
            }
        } else if Int(setColumns.value) < expenditure.count + 1 {
            memberArray.removeLast()
            resultArray.removeLast()
            totalArray.removeLast()
            expenditure.removeLast()
            for i in 0..<optionArray.count {
                optionArray[i].removeLast()
            }
        }
        let layout = UICollectionViewFlowLayout()
        let UIArea = UIScreen.main.nativeBounds.height * UIScreen.main.nativeBounds.width
        if UIArea >= 3*pow(10, 6) {
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 121, height: (expenditure[0].count + 4) * 60)
            layout.itemSize =  CGSize(width: 120, height: 45)
        } else if UIArea >= 1.2*pow(10, 6) {
            layout.itemSize = CGSize(width:80, height:30)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81, height: (expenditure[0].count + 4) * 40)
        } else {
            layout.itemSize = CGSize(width: 60, height: 90/4)
            scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 61, height: (expenditure[0].count + 4) * 30)
        }
        resetAll()
    }
    
    @objc func doneTapped(){
        UIView.animate(withDuration: 0.2){
            self.pickerToolbar.frame.origin.y = self.view.frame.height
            self.optionPicker.frame.origin.y = self.view.frame.height + self.pickerToolbarHeight
            let yMove = self.optionPickerHeight + self.pickerToolbarHeight
            self.guardView.frame.origin.y -= yMove
            self.setRows.frame.origin.y -= yMove
            self.setColumns.frame.origin.y -= yMove
            self.rowLabel.frame.origin.y -= yMove
            self.columnLabel.frame.origin.y -= yMove
            self.optionButton.frame.origin.y -= yMove
            self.calculateButton.frame.origin.y -= yMove
            self.resetButton.frame.origin.y -= yMove
        }
        resetAll()
    }
    
    @objc func selectOptions() {
        // optionPickerをリロード
        optionPicker.reloadAllComponents()
        // optionPickerを表示
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame.origin.y = self.view.frame.height - self.optionPickerHeight - self.pickerToolbarHeight
            self.optionPicker.frame.origin.y = self.view.frame.height - self.optionPickerHeight
            let yMove = self.optionPickerHeight + self.pickerToolbarHeight
            self.guardView.frame.origin.y += yMove
            self.setRows.frame.origin.y += yMove
            self.setColumns.frame.origin.y += yMove
            self.rowLabel.frame.origin.y += yMove
            self.columnLabel.frame.origin.y += yMove
            self.optionButton.frame.origin.y += yMove
            self.calculateButton.frame.origin.y += yMove
            self.resetButton.frame.origin.y += yMove
        }
    }
    
    @objc func caluculation() {
        self.view.endEditing(true)
        resetAll()
    }
    
    @objc func saveSheet() {
        self.view.endEditing(true)
        resetAll()
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
    @objc func changeTitle() {
        self.view.endEditing(true)
        resetAll()
        self.performSegue(withIdentifier: "changeTitle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeTitle" {
            let next = segue.destination as! ChangeTitleViewController
            next.titleText = ud.string(forKey: sheetBirthday + "/sheetName")
            next.sheetBirthday = sheetBirthday
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         memberArray = ["","","",""]
         resultArray = [0,0,0,0]
         totalArray = [0,0,0,0]
         expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
         optionArray = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
         */
        
        self.view.backgroundColor = myOrange
        setValues()
        loadViews()
        setButtons()
        
        // コンテンツビューにピンチジェスチャー登録 (7/13)
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action: #selector(viewPinch))
        pinchGesture.delegate=self
        view.addGestureRecognizer(pinchGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expenditure.count + 1
    }
    
    // cell のセクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return expenditure[0].count + 4
    }
    
    // Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // セルを作成か再利用する
        let cell : CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.textField?.delegate = self
        
        // セルの背景色
        cell.backgroundColor = UIColor.white
        
        // セルの枠線
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.borderWidth = 0.5
        
        // Section毎にCellのプロパティを変える.
        switch(indexPath.row){
        case 0:
            let bgView = UIView()
            bgView.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.8, alpha: 1.0)
            cell.backgroundView = bgView
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            switch(indexPath.section){
            case 0:
                cell.textLabel?.text = memberLB[lang]
            case expenditure[0].count + 1:
                cell.textLabel?.text = totalLB[lang]
            case expenditure[0].count + 2:
                cell.textLabel?.text = resultLB[lang]
            case expenditure[0].count + 3:
                cell.textLabel?.text = options[selectedOption]
            default:
                cell.textLabel?.text = indexPath.section.description
            }
        default:
            switch(indexPath.section){
            case 0:
                cell.textLabel?.isHidden = true
                cell.textField?.isEnabled = true
                cell.backgroundColor  = UIColor(red: 0.7, green: 0.8, blue: 0.95, alpha: 1.0)
                cell.textField?.adjustsFontSizeToFitWidth = true
                cell.textField?.keyboardType = UIKeyboardType.default
                cell.textField?.returnKeyType = UIReturnKeyType.done
                cell.textField?.textAlignment = NSTextAlignment.center
                cell.textField?.text = memberArray[indexPath.row - 1]
            case expenditure[0].count + 1:
                cell.textLabel?.textAlignment = NSTextAlignment.right
                cell.textLabel?.text = String(expenditure[indexPath.row - 1].reduce(0){$0 + $1})
                cell.backgroundColor = lightOrange
                cell.textLabel?.textColor = myBlue
            case expenditure[0].count + 2:
                cell.textLabel?.textAlignment = NSTextAlignment.right
                let result = resultArray[indexPath.row - 1]
                cell.textLabel?.text = String(result)
                cell.backgroundColor = lightOrange
                cell.textLabel?.textColor = myBlue
                if result < 0 {
                    cell.textLabel?.textColor = myRed
                }
            case expenditure[0].count + 3:
                cell.textLabel?.isHidden = true
                cell.textField?.isEnabled = true
                cell.textField?.keyboardType = UIKeyboardType.numberPad
                let number = optionArray[selectedOption][indexPath.row - 1]
                if number != 0 {
                    cell.textField?.text = String(number)
                }
            default:
                cell.textLabel?.isHidden = true
                cell.textField?.isEnabled = true
                cell.textField?.keyboardType = UIKeyboardType.numberPad
                let number = expenditure[indexPath.row - 1][indexPath.section - 1]
                if number != 0 {
                    cell.textField?.text = String(number)
                }
            }
        }
        
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTap))
        ]
        
        numberToolbar.sizeToFit()
        // キーボードがnumberPadの時のみToolBarを追加する
        if cell.textField?.keyboardType == UIKeyboardType.numberPad {
            cell.textField?.inputAccessoryView = numberToolbar
        }
        
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! CustomCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        switch indexPath?.section {
        case 0:
            memberArray[(indexPath?.row)! - 1] = (textField.text)!
        case expenditure[0].count + 3:
            if textField.text != "" {
                if (textField.text?.isOnlyNumeric())! {
                    optionArray[selectedOption][(indexPath?.row)! - 1] = Int(textField.text!)!
                } else {
                    let numberAlert = UIAlertController(title: numberAlertTitle[lang], message: numberAlertMessage[lang], preferredStyle: .alert)
                    numberAlert.view.tintColor = myRed
                    numberAlert.addAction(UIAlertAction(title: OKLB[lang], style: .default, handler: nil))
                    present(numberAlert, animated: true, completion: nil)
                    textField.text = ""
                    resetAll()
                }
            } else {
                optionArray[selectedOption][(indexPath?.row)! - 1] = 0
            }
        default:
            if textField.text != "" {
                if (textField.text?.isOnlyNumeric())! {
                    expenditure[(indexPath?.row)! - 1][(indexPath?.section)! - 1] = Int((textField.text)!)!
                } else {
                    let numberAlert = UIAlertController(title: numberAlertTitle[lang], message: numberAlertMessage[lang], preferredStyle: .alert)
                    numberAlert.view.tintColor = myRed
                    numberAlert.addAction(UIAlertAction(title: OKLB[lang], style: .default, handler: nil))
                    present(numberAlert, animated: true, completion: nil)
                    textField.text = ""
                    resetAll()
                }
            } else {
                expenditure[(indexPath?.row)! - 1][(indexPath?.section)! - 1] = 0
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = row
    }
    
    // 画面の回転に対応
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.endEditing(true)
        resetAll()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
//        print(keyboardHeight)
    }
    
    func resetAll() {
        collectionView.removeFromSuperview()
        scrollView.removeFromSuperview()
        guardView.removeFromSuperview()
        view.backgroundColor = myOrange
        setValues()
        loadViews()
        setButtons()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // キーボードの高さ (7/18)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.post(name: .UIKeyboardWillShow, object: self)
        
//        numberToolbar.frame.size.height = view.frame.height > view.frame.width ? 40 : 30 // 多分機能してない
        let cell = textField.superview?.superview as! CustomCollectionViewCell
        NotificationCenter.default.post(name: .UIKeyboardWillShow, object: self)
//        let bottomTextField = cell.frame.maxY + cell.frame.height
        let topKeyboard = view.frame.size.height - keyboardHeight - numberToolbar.frame.size.height
//        let distance = bottomTextField - topKeyboard
        let distance = cell.frame.maxY - topKeyboard
        print("cell.frame.maxY",cell.frame.maxY)
        print("cell.frame.height",cell.frame.height)
        print("view.frame.size.height",view.frame.size.height)
        print("keyboardHeight",keyboardHeight)
        print("numberToolbar.frame.height",numberToolbar.frame.height)
        if distance >= 0 {
            // scrollViewのコンテツを上へオフセット
            scrollView.contentOffset.y = distance + cell.frame.size.height
//            scrollView.contentOffset.y = view.frame.height > view.frame.width ? distance + cell.frame.size.height : distance
        }
        return true
    }
    
    /*  7/18に追加  キーボードの高さに関するところ*/
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        keyboardHeight = keyboardSize.height
//        keyboardHeight = KeyboardService.keyboardHeight()
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0) //←
        UIView.animate(withDuration: duration, animations: {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // 6/22 sheetNameを編集してから戻ってきた時
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ud.string(forKey: sheetBirthday + "/sheetName")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Viewの表示時にキーボード表示・非表示時を監視していたObserverを解放する
        super.viewWillDisappear(animated)
        let notification = NotificationCenter.default
        notification.removeObserver(self)
        notification.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notification.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // ここから下は7/13以降に追加
    var currentScale: CGFloat = 1.0
    @objc func viewPinch(sender: UIPinchGestureRecognizer) {
        // imageViewを拡大縮小する
        // ピンチ中の拡大率は0.3〜2.0倍、指を離した時の拡大率は0.5〜1.5倍とする
        switch sender.state {
        case .began, .changed:
            // senderのscaleは、指を動かしていない状態が1.0となる
            // 現在の拡大率に、(scaleから1を引いたもの) / 10(補正率)を加算する
            currentScale = currentScale + (sender.scale - 1) / 10
            // 拡大率が基準から外れる場合は、補正する
            if currentScale < 0.3 {
                currentScale = 0.3
            } else if currentScale > 2.0 {
                currentScale = 2.0
            }
            // 計算後の拡大率で、imageViewを拡大縮小する
            collectionView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        default:
            // ピンチ中と同様だが、拡大率の範囲が異なる
            if currentScale < 0.5 {
                currentScale = 0.5
            } else if currentScale > 1.5 {
                currentScale = 1.5
            }
            // 拡大率が基準から外れている場合、指を離したときにアニメーションで拡大率を補正する
            // 例えば指を離す前に拡大率が0.3だった場合、0.2秒かけて拡大率が0.5に変化する
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.transform = CGAffineTransform(scaleX: self.currentScale, y: self.currentScale)
            }, completion: nil)
        }
    }
}

extension String {
    public func isOnly(_ characterSet: CharacterSet) -> Bool {
        return self.trimmingCharacters(in: characterSet).count <= 0
    }
    public func isOnlyNumeric() -> Bool {
        return isOnly(.decimalDigits)
    }
    public func isOnly(_ characterSet: CharacterSet, _ additionalString: String) -> Bool {
        var replaceCharacterSet = characterSet
        replaceCharacterSet.insert(charactersIn: additionalString)
        return isOnly(replaceCharacterSet)
    }
}

// キーボードの高さを取得するためのクラス
class KeyboardService: NSObject {
    static var serviceSingleton = KeyboardService()
    var measuredSize: CGRect = CGRect.zero
    
    @objc class func keyboardHeight() -> CGFloat {
        let keyboardSize = KeyboardService.keyboardSize()
        return keyboardSize.height
    }
    
    @objc class func keyboardSize() -> CGRect {
        return serviceSingleton.measuredSize
    }
    
    private func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardChange), name: .UIKeyboardDidShow, object: nil)
    }
    
    private func observeKeyboard() {
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }
    
    @objc private func keyboardChange(_ notification: Notification) {
        guard measuredSize == CGRect.zero, let info = notification.userInfo,
            let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        measuredSize = value.cgRectValue
    }
    
    override init() {
        super.init()
        observeKeyboardNotifications()
        observeKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
