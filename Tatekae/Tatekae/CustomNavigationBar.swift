//
//  CustomNavigationBar.swift
//  Tatekae
//
//  Created by 鈴木健一 on 2018/06/19.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    

   
    /*
    //デフォルトよりどれだけ高くするか
    let addHeight:CGFloat = 40.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        self.barTintColor = UIColor.blue
        self.tintColor = UIColor.white
        self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        //渡されるsizeは widthは決まっているがheightは決まっていない
        //super.sizeThatFits(size)でheightが決まる
        var newSize = super.sizeThatFits(size)
        
        //iphoneX用
        var topInset:CGFloat = 0
        if #available(iOS 11.0, *) {
            topInset = superview?.safeAreaInsets.top ?? 0
        }
        
        newSize.height += addHeight + topInset  //通常よりどれだけ大きくするか
        
        return newSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            for subview in self.subviews {
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                if stringFromClass.contains("BarBackground") {
                    //ステータスバー分あげないと余白ができる。
                    let statusBarHeight = UIApplication.shared.statusBarFrame.height
                    let point = CGPoint(x:0,y:-statusBarHeight)
                    //ここでバーの高さを調節 (sizeThatFitsを呼び出す)
                    subview.frame = CGRect(origin: point, size: sizeThatFits(self.bounds.size))
                }else if stringFromClass.contains("BarContentView") {
                    //ここでサブビューの位置を調整
                    subview.frame.origin.y = addHeight
                }
            }
        }
    }
     */

}
