//
//  ViewController.swift
//  ScrollAndCollection
//
//  Created by 鈴木健一 on 2018/06/01.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    // ビューとボタンの設定
    var scrollView: UIScrollView!
    var collectionView: UICollectionView!
//    var addColumnButton =  UIButton()
//    var addRowButton = UIButton()
    var resetButton = UIButton()
    var optionButton = UIButton()
    let numberToolbar: UIToolbar = UIToolbar()
    
    let setRows = UIStepper()
    let setColumns = UIStepper()
    
    var optionPicker = UIPickerView()
    let optionPickerHeight: CGFloat = 120
    let options = ["+○○○円","-○○○円","+○○%","-○○%"]
    var optionText = "option"
    var pickerToolbar: UIToolbar = UIToolbar()
    let pickerToolbarHeight: CGFloat = 40
    
    let ud  = UserDefaults.standard
    
    // 情報の保存
    var expenditure: [[Int]] {
        get {
            return ud.array(forKey: "expenditure") as! [[Int]]
        }
        set {
            ud.set(newValue, forKey: "expenditure")
            ud.synchronize()
        }
    }
    
    var memberArray: [String] {
        get {
            return ud.array(forKey: "member") as! [String]
        }
        set {
            ud.set(newValue, forKey: "member")
            ud.synchronize()
        }
    }
    
    var totalArray: [Int] {
        get {
            return ud.array(forKey: "total") as! [Int]
        }
        set {
            ud.set(newValue.self, forKey: "total")
            ud.synchronize()
        }
    }
    
    var resultArray: [Int] {
        get {
            return ud.array(forKey: "result") as! [Int]
        }
        set {
            ud.set(newValue, forKey: "result")
            ud.synchronize()
        }
    }
    
    var opValueArray: [Int] {
        get {
            return ud.array(forKey: "opValue") as! [Int]
        }
        set {
            ud.set(newValue, forKey: "opValue")
            ud.synchronize()
        }
    }
    
    var opPercentArray: [Int] {
        get {
            return ud.array(forKey: "opPercent") as! [Int]
        }
        set {
            ud.set(newValue, forKey: "opPercent")
            ud.synchronize()
        }
    }

    // よく使う関数
    func setValues() {
        if ud.array(forKey: "member") == nil {
            memberArray = ["","","",""]
        }
        if ud.array(forKey: "result") == nil {
            resultArray = [0,0,0,0]
        }
        if ud.array(forKey: "total") == nil {
            totalArray = [0,0,0,0]
        }
        if ud.array(forKey: "expenditure") == nil {
            expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
        }
        if ud.array(forKey: "opValue") == nil {
            opValueArray = [0,0,0,0,0]
        }
        if ud.array(forKey: "opPercent") == nil {
            opPercentArray = [0,0,0,0,0]
        }
        calcurateResult()
    }
    
    func loadViews() {
        /* scroll view */
        // Screen Size の取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        let xStart:CGFloat = 0
        let yStart:CGFloat = 80 + statusBarHeight
        
        // scrollViewを設置する座標
        let rectSize = CGRect(x:xStart,y:yStart,width:screenWidth,height:screenHeight)
        scrollView = UIScrollView(frame: rectSize)
        
        // scrollViewの大きさ
        scrollView.contentSize = CGSize(width: (expenditure.count + 1) * 81,
                                        height: (expenditure[0].count + 4) * 40)
        
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
        
        // Cellのマージン.
        // layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // セクション毎のヘッダーサイズ.
        // layout.headerReferenceSize = CGSize(width:100,height:30)
        
        // layout.scrollDirection = .horizontal
        
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
        if options.index(of: optionText) != nil {
            optionPicker.selectRow(options.index(of: optionText)!, inComponent: 0, animated: true)
        }
        self.view.addSubview(optionPicker)
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame:CGRect(x:0,y:height,width:width,height:pickerToolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped))
        //        let doneBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.doneTapped))
        pickerToolbar.items = [flexible,doneBtn]
        self.view.addSubview(pickerToolbar)
    }
    
    func calcurateResult() {
        let sum: Int = totalArray.reduce(0){$0+$1}
        for i in 0..<resultArray.count {
            resultArray[i] = Int(round(Double(totalArray[i] - sum / totalArray.count)))
        }
    }
    
    @objc func onTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    /*
    @objc func addRow(sender: Any) {
        // buttonの色を変化させるメソッド
        // addColumnButton.backgroundColor = UIColor.darkGray
        for i in 0..<expenditure.count {
            expenditure[i].append(0)
        }
        scrollView.contentSize = CGSize(width: (3 + expenditure[0].count) * 81,
                                        height: (memberArray.count + 1) * 40)
        setValues()
        // collectionView.reloadData()
        loadViews()
        // print("memberArray: ",memberArray)
    }
    */
    
    /*
    @objc func addColumn(sender: Any) {
        memberArray.append("")
        resultArray.append(0)
        totalArray.append(0)
        expenditure.append([])
        for _ in 0..<expenditure[0].count {
            expenditure[expenditure.count-1].append(0)
        }
        
        setValues()
        loadViews()
        // print("memberArray: ", memberArray)
    }
     */
    
    @objc func reset(sender:Any) {
        memberArray = ["","","",""]
        resultArray = [0,0,0,0]
        totalArray = [0,0,0,0]
        expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
        opValueArray = [0,0,0,0]
        opPercentArray = [0,0,0,0]
        setRows.value = Double(expenditure[0].count)
        setColumns.value = Double(expenditure.count + 1)
        setValues()
        loadViews()
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
        } else if Int(setColumns.value) < expenditure.count + 1 {
            memberArray.removeLast()
            resultArray.removeLast()
            totalArray.removeLast()
            expenditure.removeLast()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        memberArray = ["","","",""]
        resultArray = [0,0,0,0]
        totalArray = [0,0,0,0]
        expenditure = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
        */
        
        
        setValues()
        loadViews()
 
        
        /* addColumnButton
        addColumnButton.frame = CGRect(x: view.frame.size.width - 130, y: 10, width: 100, height: 60)
        // ボタンの設置座標とサイズを設定する.
        addColumnButton.backgroundColor = UIColor.cyan
        // buttonのbackgroundcolorを指定
        addColumnButton.setTitle("add column", for: .normal)
        // 通常時のbuttonの文字を指定
        addColumnButton.addTarget(self, action: #selector(ViewController.addColumn(sender: )), for: .touchUpInside)
        // buttonにイベントを追加
        view.addSubview(addColumnButton)
        // 実際にviewに表示する
         */
        
        /* addRowButton
        addRowButton.frame = CGRect(x: view.frame.size.width - 240, y: 10, width: 100, height: 60)
        // ボタンの設置座標とサイズを設定する.
        addRowButton.backgroundColor = UIColor.blue
        // buttonのbackgroundcolorを指定
        addRowButton.setTitle("add row", for: .normal)
        // 通常時のbuttonの文字を指定
        addRowButton.addTarget(self, action: #selector(ViewController.addRow(sender: )), for: .touchUpInside)
        // buttonにイベントを追加
        view.addSubview(addRowButton)
        // 実際にviewに表示する
        */
        
        /* resetButton */
        resetButton.frame = CGRect(x: view.frame.size.width - 90, y: 10 + statusBarHeight, width: 80, height: 40)
        // ボタンの設置座標とサイズを設定する.
        resetButton.backgroundColor = UIColor.green
        // buttonのbackgroundcolorを指定
        resetButton.setTitle("Reset", for: .normal)
        // 通常時のbuttonの文字を指定
        resetButton.addTarget(self, action: #selector(ViewController.reset(sender: )), for: .touchUpInside)
        // buttonにイベントを追加
        view.addSubview(resetButton)
        // 実際にviewに表示する
        
        /* optioButton */
        optionButton.frame = CGRect(x: view.frame.width - 180, y: 10 + statusBarHeight, width: 80, height: 40)
        optionButton.backgroundColor = UIColor(red: 0.6, green: 0.2, blue: 0.6, alpha: 1.0)
        optionButton.setTitle("option", for: .normal)
        optionButton.addTarget(self, action: #selector(self.selectOptions), for: .touchUpInside)
        view.addSubview(optionButton)
        
        /* recognizer
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(recognizer)
            */
        
        setRows.frame.origin = CGPoint(x: 10, y: statusBarHeight + 10)
        view.addSubview(setRows)
        setRows.addTarget(self, action: #selector(onChangeRows), for: .valueChanged)
        setRows.autorepeat = false
        setRows.minimumValue = 2
        setRows.value = Double(expenditure[0].count)
        
        setColumns.frame.origin = CGPoint(x: 120, y: statusBarHeight + 10)
        view.addSubview(setColumns)
        setColumns.addTarget(self, action: #selector(onChangeColumns), for: .valueChanged)
        setColumns.autorepeat = false
        setColumns.minimumValue = 2
        setColumns.value = Double(expenditure.count + 1)
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
        /*
        //ピッカービューとセルがかぶる時はスクロール
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        let cellLimit:CGFloat = cell.frame.origin.y + cell.frame.height
        let pickerViewLimit:CGFloat = optionPicker.frame.height + pickerToolbarHeight
        if cellLimit >= pickerViewLimit {
            print("位置変えたい")
            UIView.animate(withDuration: 0.2) {
                collectionView.contentOffset.y = cellLimit - pickerViewLimit
            }
        }
         */
        print("[行,列] = [\(indexPath.section), \(indexPath.row)]")
        /*
        if indexPath.row == 0 && indexPath.section == expenditure[0].count + 3 {
            pickerIndexPath = indexPath
            // optionPickerをリロード
            optionPicker.reloadAllComponents()
            // optionPickerを表示
            UIView.animate(withDuration: 0.2) {
                self.pickerToolbar.frame.origin.y = self.view.frame.height - self.optionPickerHeight - self.pickerToolbarHeight
                self.optionPicker.frame.origin.y = self.view.frame.height - self.optionPickerHeight
            }
        }
        */
        
        /*
         let alertController = UIAlertController(
         title: nil,
         message: "タッチしたセルは\(indexPath.row)です",
         preferredStyle: .alert
         )
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alertController, animated: true, completion: nil)
         */
        
        // collectionView.reloadItems(at: [indexPath])
    }
    /*
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
     let cell: CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomCollectionViewCell
     cell.textField?.text = "kjhgfd"
     }
     */
    
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
            // cell.textLabel?.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.8, alpha: 1.0)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            switch(indexPath.section){
            case 0:
                cell.textLabel?.text = "member"
            case expenditure[0].count + 1:
                cell.textLabel?.text = "total"
            case expenditure[0].count + 2:
                cell.textLabel?.text = "result"
            case expenditure[0].count + 3:
                cell.textLabel?.text = optionText
//                cell.textLabel?.textColor = UIColor.blue
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
                totalArray[indexPath.row - 1] = Int((cell.textLabel?.text)!)!
                // print("totalArray: ", totalArray)
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
            default:
                cell.textLabel?.isHidden = true
                cell.textField?.isEnabled = true
                cell.textField?.keyboardType = UIKeyboardType.numberPad
                let number = expenditure[indexPath.row - 1][indexPath.section - 1]
                if number != 0 {
                    cell.textField?.text = String(number)
                }
                /*
                let value: Int = expenditure[indexPath.section - 1][indexPath.row - 1]
                // cell.textField?.text  = String(value)
                expenditure[indexPath.section - 1][indexPath.row - 1] = value
                print("expenditure[0].count: " ,expenditure[0].count)
                 */
            }
                /*
            cell.textLabel?.isHidden = true
            cell.textField?.isEnabled = true
            if indexPath.row == 0 {
                cell.backgroundColor  = UIColor.lightGray
                cell.textField?.keyboardType = UIKeyboardType.default
                cell.textField?.returnKeyType = UIReturnKeyType.done
                cell.textField?.textAlignment = NSTextAlignment.center
                cell.textField?.text = memberArray[indexPath.section - 1]
            } else {
                cell.textField?.keyboardType = UIKeyboardType.numberPad
            }
 */
        }
        
        
        /*
        let button: UIButton = UIButton(type: .system)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        
        func boopla () {
            cell.textField?.resignFirstResponder()
        }
        
        func hoopla () {
            cell.textField?.text=""
            cell.textField?.resignFirstResponder()
        }
         */
        
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            // UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:"hoopla"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            //UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onTap)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTap))
        ]
        
        numberToolbar.sizeToFit()
        
        // キーボードがnumbarPadの時のみToolBarを追加する
        if cell.textField?.keyboardType == UIKeyboardType.numberPad {
            cell.textField?.inputAccessoryView = numberToolbar
            //do it for every relevant textfield if there are more than one
        }
        
        // 選択中のセルの背景をグレーに
        /*
        let bgView = UIView()
        bgView.backgroundColor = .lightGray
        cell.selectedBackgroundView = bgView
         */
        
        return cell
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! CustomCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        switch indexPath?.section {
        case 0:
            memberArray[(indexPath?.row)! - 1] = (textField.text)!
        case expenditure[0].count + 3:
            break
        default:
            if textField.text != "" {
                expenditure[(indexPath?.row)! - 1][(indexPath?.section)! - 1] = Int((textField.text)!)!
                totalArray[(indexPath?.row)! - 1] += Int((textField.text)!)!
                print(indexPath!, textField.text!)
            }
        }
        
        loadViews()
        calcurateResult()
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
        optionText = options[row]
    }
 
    
}

