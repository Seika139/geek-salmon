//
//  OpenViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/16.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let darkOrange = UIColor(red: 242/256, green: 188/256, blue: 9/256, alpha: 1.0)
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
    @IBOutlet var tableView: UITableView!
    
    var lang: Int {
        get {
            return ud.integer(forKey: "langNum")
        }
        set {
            ud.set(newValue, forKey: "langNum")
            ud.synchronize()
        }
    }
    let naviBarLB = ["Open File","ファイルを開く","打开文件","파일을 열기","Abrir archivo","Fichier ouvert"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = naviBarLB[lang]
        tableView.dataSource = self
        tableView.delegate = self
        loadTable()
    }

    func loadTable() {
        if ud.string(forKey: "titleArray") != nil {
            tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = ud.string(forKey: titleArray[indexPath.row]+"/sheetName")
        cell.textLabel?.textColor = darkOrange
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMain", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            let mainVC = segue.destination as! MainViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            mainVC.sheetBirthday = titleArray[selectedIndexPath.row]
        }
    }
    
    // セルをスワイプで削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ud.removeObject(forKey: titleArray[indexPath.row] + "/sheetName")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/member")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/expenditure")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/total")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/result")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/option")
            ud.removeObject(forKey: titleArray[indexPath.row] + "/selectedOption")
            ud.synchronize()
            titleArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
