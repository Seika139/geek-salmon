//
//  CustomCollectionViewCell.swift
//  ScrollAndCollection
//
//  Created by 鈴木健一 on 2018/06/01.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var textLabel : UILabel?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var textField : UITextField?
    @objc func onExit(sender:Any){} // 完了ボタンでキーボードを閉じるのに必要
    
    /*
    @objc func onSwipe(sender: UISwipeGestureRecognizer) {
        print("asdfg")
    }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成.
        textLabel = UILabel(frame: CGRect(x: 10, y:0, width:frame.width - 20, height:frame.height))
        textLabel?.text = "nil"
        textLabel?.backgroundColor = UIColor.clear
        textLabel?.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(textLabel!)
        
        // UITextFieldを生成(6/4)
        textField = UITextField(frame: CGRect(x:10, y:0, width:frame.width - 20, height:frame.height))
        textField?.isEnabled = false // テキストフィールドが有効かどうか
        textField?.addTarget(self, action: #selector(onExit), for: .editingDidEndOnExit) // 完了ボタンでキーボードを閉じる
        textField?.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(textField!)
        
        /*
        let swiped = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        addGestureRecognizer(swiped)
         */
    }
}
