//
//  GridViewController.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/05/25.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // @IBOutlet weak var collectionView: UICollectionView!
    var scrollView: UIScrollView!
    var myCollectionView : UICollectionView!

    
    let items: [CGFloat] = [
        1.0,
        2.0,
        3.0,
        4.0,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        ]
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.allowsSelection = true // 選択可能にする
 
        /*新規に追加*/
        scrollView.contentSize = CGSize(width: 1000.0, height: 1000.0)
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:50, height:50)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16)
        
        // セクション毎のヘッダーサイズ.
        //layout.headerReferenceSize = CGSize(width:100,height:30)
        
        layout.scrollDirection = .horizontal

        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        // Screen Size の取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        myCollectionView.frame = CGRect(x:0, y:screenHeight/2, width:screenWidth, height:50)
        
        // Cellに使われるクラスを登録.
        myCollectionView.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        myCollectionView.backgroundColor = UIColor.clear
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
        
        
    }
    
    // Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        
    }
    
    // Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    // Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CustomUICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomUICollectionViewCell
        cell.textLabel?.text = indexPath.row.description
        
        return cell
    }
    
    /*新規に追加ここまで*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count // itemsの個数だけセルを表示する
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // セルを作成か再利用する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        
        cell.contentView.layer.borderColor = UIColor.black.cgColor // 枠線の色を黒に
        cell.contentView.layer.borderWidth = items[indexPath.row]  // itemsからデータを取得して枠線の太さに設定
        
        // 選択中のセルの背景をグレーに
        let bgView = UIView()
        bgView.backgroundColor = .lightGray
        cell.selectedBackgroundView = bgView
        
        //セルのラベルに番号を設定する。
        cell.testLabel.text = String(indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: nil,
            message: "ボーダーの太さは\(items[indexPath.row])です",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
