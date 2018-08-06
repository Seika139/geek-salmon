//
//  ConfigViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/06/27.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myOrange = UIColor(red: 246/256, green: 206/256, blue: 76/256, alpha: 1.0)
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)
    let ud = UserDefaults.standard
    let langArray: [String] = ["English","日本語","中文","한국어","Español","Français"]
    let configLB = ["Config","設定","设定","설정","Ajuste","Réglage"]
    let saveLB = ["Save","保存","保存","저장","Guardar","Garder"]
    var langTableView = UITableView()
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    var subLangNum: Int = 0
    var langNum: Int {
        get {
            return ud.integer(forKey: "langNum")
        }
        set {
            ud.set(newValue, forKey: "langNum")
            ud.synchronize()
        }
    }
    
    func loadTableView() {
        langTableView = UITableView(frame: self.view.bounds, style: .plain)
        langTableView.dataSource = self
        langTableView.delegate = self
        langTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(langTableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subLangNum = langNum
        loadTableView()
        
        let rightButton = UIBarButtonItem(title: saveLB[langNum], style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveLanguage))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = configLB[langNum]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = langArray[indexPath.row]
        cell.tintColor = darkOrange
        cell.textLabel?.textColor = darkOrange
        return cell
    }
    
    // 画面の回転に対応
    // viewWillAppearより後に発動するのでここで元のところにチェックマークをつける
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadTableView()
        self.langTableView.selectRow(at: IndexPath(row: subLangNum, section: 0), animated: false, scrollPosition: UITableViewScrollPosition(rawValue: subLangNum)!)
        let cell = self.langTableView.cellForRow(at: IndexPath(row: subLangNum, section: 0))
        cell?.accessoryType = .checkmark
        langTableView.deselectRow(at: IndexPath(row: subLangNum, section: 0), animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delCell = self.langTableView.cellForRow(at: IndexPath(row: subLangNum, section: 0))
        let cell = tableView.cellForRow(at: indexPath)
        delCell?.accessoryType = .none
        cell?.accessoryType = .checkmark
        subLangNum = indexPath.row
        langTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func saveLanguage() {
        langNum = subLangNum
        self.navigationController?.popViewController(animated: true)
    }
    
}
