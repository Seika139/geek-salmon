//
//  ViewController.swift
//  SpmpleTableView
//
//  Created by 鈴木健一 on 2018/05/10.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 食べ物のデータを入れる変数
    
    var foods = [["name":"カレー","image":"curry.jpg"],
                 ["name":"寿司","image":"sushi.jpg"],
                 ["name":"ラーメン","image":"ramen.png"],
                 ["name":"ハンバーグ","image":"humberg.jpg"]]
    
    // TableView
    @IBOutlet var foodTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // データソースメソッドをこのファイルの中で処理する
        foodTableView.dataSource = self
        // デリゲートメソッドをselfに任せる
        foodTableView.delegate = self
        
        // TableVeiw の不要な線を消す
        foodTableView.tableFooterView = UIView()
        
        // カスタムセルの登録
        let nib = UINib(nibName: "FoodTableViewCell", bundle: Bundle.main)
        foodTableView.register(nib, forCellReuseIdentifier: "cell2")
        
        foodTableView.rowHeight = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 1. TableViewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    // TableView に表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // idをつけたcellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! FoodTableViewCell
        // 表示内容を決める
        // cell.textLabel?.text = foods[indexPath.row]
        /*
        let foodImageView = cell.viewWithTag(1) as! UIImageView
        let foodNameLabel = cell.viewWithTag(2) as! UILabel
        
        foodImageView.image = foodImages[indexPath.row]
        foodNameLabel.text = foods[indexPath.row]
        */
        let imageName = foods[indexPath.row]["image"]
        cell.foodImageView.image = UIImage(named: imageName!)
        cell.foodNameLabel.text = foods[indexPath.row]["name"]
        
        // cell を返す
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        // 選択状態の解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! MiniViewController
        let selectedIndex = foodTableView.indexPathForSelectedRow!
        detailViewController.selectedName = foods[selectedIndex.row]["name"]!
    }
}

