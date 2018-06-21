//
//  MainViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/06/19.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource{

    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    // ビューとボタンの設定
    var scrollView: UIScrollView!
    var collectionView: UICollectionView!
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
    let options = ["+○○○円","-○○○円","+○○%","-○○%"]
    var pickerToolbar: UIToolbar = UIToolbar()
    let pickerToolbarHeight: CGFloat = 40
    let ud = UserDefaults.standard
    

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
        //カスタムの戻るボタンを作成
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveSheet))
        self.navigationItem.rightBarButtonItem = rightButton
        
        /* scrollView */
        // ScreenSizeの取得
        let screenWidth: CGFloat = view.frame.size.width
        let screenHeight: CGFloat = view.frame.size.height
        let xStart: CGFloat = 0
        let yStart: CGFloat = 80 + navigationBarHeight + statusBarHeight
        // scrollViewを設置する座標
        let rectSize = CGRect(x: xStart, y: yStart, width: screenWidth, height: screenHeight)
        scrollView = UIScrollView(frame: rectSize)
        // scrollViewの大きさ
        scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81, height: (expenditure[0].count + 4) * 40)
        // 背景色の設定
        scrollView.backgroundColor = UIColor.yellow
        // 親のビューにサブビュー(scrollView)を追加
        self.view.addSubview(scrollView)
        
        /* layout */
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:80, height:30)
        layout.minimumInteritemSpacing = 0.1 // セルの横の隙間
        layout.minimumLineSpacing = 0 // セルの縦の隙間
        // CollectionViewを生成.
        collectionView = UICollectionView(frame: self.scrollView.frame, collectionViewLayout: layout)
        
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
        
        //pickerView
        let height = self.view.frame.height
        let width = self.view.frame.width
        optionPicker = UIPickerView(frame:CGRect(x:0,y:height + pickerToolbarHeight,
                                                 width:width,height:optionPickerHeight))
        optionPicker.dataSource = self
        optionPicker.delegate = self
        optionPicker.backgroundColor = UIColor.gray
        optionPicker.selectRow(selectedOption, inComponent: 0, animated: true)
        self.view.addSubview(optionPicker)
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame:CGRect(x:0,y:height,width:width,height:pickerToolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped))
        pickerToolbar.items = [flexible,doneBtn]
        self.view.addSubview(pickerToolbar)
    }
    
    @objc func onTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func reset(sender:Any) {
        let alert = UIAlertController(title: "Reset",
                                      message: "Registration on this File will be all cleared.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.memberArray = ["","","",""]
            self.resultArray = [0,0,0,0]
            self.totalArray = [0,0,0,0]
            self.expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
            self.optionArray = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
            self.setRows.value = Double(self.expenditure[0].count)
            self.setColumns.value = Double(self.expenditure.count + 1)
            self.setValues()
            self.loadViews()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onChangeRows(sender: UIStepper) {
        if Int(setRows.value) > expenditure[0].count {
            for i in 0..<expenditure.count {
                expenditure[i].append(0)
            }
        } else if Int(setRows.value) < expenditure[0].count {
            for i in 0..<expenditure.count {
                expenditure[i].removeLast()
            }
        }
        scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81,
                                        height: (expenditure[0].count + 4) * 40)
        setValues()
        loadViews()
    }
    
    @objc func onChangeColumns(sender: UIStepper) {
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
        scrollView.contentSize = CGSize(width: (expenditure.count  + 1) * 81,
                                        height: (expenditure[0].count + 4) * 40)
        setValues()
        loadViews()
    }
    
    @objc func doneTapped(){
        UIView.animate(withDuration: 0.2){
            self.pickerToolbar.frame.origin.y = self.view.frame.height
            self.optionPicker.frame.origin.y = self.view.frame.height + self.pickerToolbarHeight
            //            self.collectionView.contentOffset.y = 0
        }
        loadViews()
    }
    
    @objc func selectOptions() {
        // optionPickerをリロード
        optionPicker.reloadAllComponents()
        // optionPickerを表示
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame.origin.y = self.view.frame.height - self.optionPickerHeight - self.pickerToolbarHeight
            self.optionPicker.frame.origin.y = self.view.frame.height - self.optionPickerHeight
        }
    }
    
    @objc func caluculation() {
        self.view.endEditing(true)
        setValues()
        loadViews()
    }
    
    @objc func saveSheet() {
        self.view.endEditing(true)
        setValues()
        loadViews()
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
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
        
        setValues()
        loadViews()
        
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height

        /* resetButton */
        resetButton.frame = CGRect(x: view.frame.size.width - 65, y: 10 + navigationBarHeight+statusBarHeight,
                                   width: 60, height: 40)
        resetButton.backgroundColor = UIColor.green
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetButton.addTarget(self, action: #selector(self.reset(sender: )), for: .touchUpInside)
        view.addSubview(resetButton)
        
        /* optioButton */
        optionButton.frame = CGRect(x: view.frame.width - 195, y: 10 + navigationBarHeight + statusBarHeight,
                                    width: 60, height: 40)
        optionButton.backgroundColor = UIColor(red: 0.6, green: 0.2, blue: 0.6, alpha: 1.0)
        optionButton.setTitle("Option", for: .normal)
        optionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        optionButton.addTarget(self, action: #selector(self.selectOptions), for: .touchUpInside)
        view.addSubview(optionButton)
        
        /* calculateButton */
        calculateButton.frame = CGRect(x: view.frame.width - 130, y: 10 + navigationBarHeight + statusBarHeight,
                                                               width: 60, height: 40)
        calculateButton.backgroundColor = UIColor(red: 0.4, green: 0.7, blue: 0.5, alpha: 1.0)
        calculateButton.setTitle("Calculate", for: .normal)
        calculateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        calculateButton.addTarget(self, action: #selector(self.caluculation), for: .touchUpInside)
        view.addSubview(calculateButton)
        
        /* setRows */
        setRows.frame.origin = CGPoint(x: 10, y: 10 + navigationBarHeight + statusBarHeight)
        view.addSubview(setRows)
        setRows.addTarget(self, action: #selector(onChangeRows), for: .valueChanged)
        setRows.autorepeat = false
        setRows.minimumValue = 2
        setRows.value = Double(expenditure[0].count)
        
        /* setColumns */
        setColumns.frame.origin = CGPoint(x: 120, y: 10 + navigationBarHeight + statusBarHeight)
        view.addSubview(setColumns)
        setColumns.addTarget(self, action: #selector(onChangeColumns), for: .valueChanged)
        setColumns.autorepeat = false
        setColumns.minimumValue = 2
        setColumns.value = Double(expenditure.count + 1)
        
        /* rowLabel & columnLabel */
        rowLabel.text = "row"
        columnLabel.text = "column"
        rowLabel.sizeToFit()
        columnLabel.sizeToFit()
        rowLabel.center = CGPoint(x: 60, y: 55 + navigationBarHeight + statusBarHeight)
        columnLabel.center = CGPoint(x: 170, y: 55 + navigationBarHeight + statusBarHeight)
        view.addSubview(rowLabel)
        view.addSubview(columnLabel)
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
        print("didSelectItemAt  [行,列] = [\(indexPath.section), \(indexPath.row)]")
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
                cell.textLabel?.text = "member"
            case expenditure[0].count + 1:
                cell.textLabel?.text = "total"
            case expenditure[0].count + 2:
                cell.textLabel?.text = "result"
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
            case expenditure[0].count + 2:
                cell.textLabel?.textAlignment = NSTextAlignment.right
                let result = resultArray[indexPath.row - 1]
                cell.textLabel?.text = String(result)
                if result < 0 {
                    cell.textLabel?.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
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
        
        // キーボードがnumbarPadの時のみToolBarを追加する
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
                optionArray[selectedOption][(indexPath?.row)! - 1] = Int(textField.text!)!
            } else {
                optionArray[selectedOption][(indexPath?.row)! - 1] = 0
            }
        default:
            if textField.text != "" {
                expenditure[(indexPath?.row)! - 1][(indexPath?.section)! - 1] = Int((textField.text)!)!
                print("textFieldDidEndEditing  ",indexPath!, textField.text!)
            } else {
                expenditure[(indexPath?.row)! - 1][(indexPath?.section)! - 1] = 0
            }
        }
        /*
        loadViews()
        calcurateResult()
         */
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
    

}
