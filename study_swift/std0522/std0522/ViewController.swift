//
//  ViewController.swift
//  std0522
//
//  Created by 鈴木健一 on 2018/05/22.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // C2 -- 基本的文法の勉強
        // 1.定数と変数
        let num1 = 10 // 定数
        var num2 = 20 // 変数
        
        print(num1+num2)
        num2 += 2
        print(num1+num2)
        
        // 2.レンジ演算子
        let range1 = num1 ... num2 // num1以上num2以下
        let range2 = num1 ..< num2 // num1以上num2未満
        print(range1.contains(22))
        print(range2.contains(22))
        
        // 3. for文
        /*
         for 定数 in データ {
            処理
            データ（シーケンス）にはレンジ、配列、文字列、辞書などが入る
            定数を処理で用いいない場合には_を指定する
            stride とは指定した数ずつ増えるカウンター
                 stride(from:0,to:10,by2) -> 0,2,4,6,8
                 stride(from:0,through:10,by2) -> 0,2,4,6,8,10
         }
        */
        
        // 4.if文
        /*
         if 条件1 {
            処理1
         } else if 条件2 {
            処理2
         } else 条件3 {
            処理3
         }
         */
        for i in 0...10 {
            if i >= 5 && num2 >= 5 {
                print("iとnum2は５以上です")
            } else {
                print("iとnum2の少なくともどちらかは５未満です")
            }
        }
        
        // 三項演算子
        // 条件 ? trueの処理　: falseの処理
        for i in 0...5 {
            let ans1 = i % 2 == 1 ? "num3は奇数" : i==0 ? "num3は0" : "num3は偶数"
            print(ans1)
        }
        
        // 5.while文
        /*
         while 条件 {
            処理
            if スキップする条件 {
                continue
            }
            if ループを終了する条件 {
                break
            }
         }
        */
        
        // repeat-while文 >> 条件判定を後で行うので初回は必ず実行される
        /*
        repeat {
            処理
         } while 条件
         */
        
        var num3 = 10
        repeat {
            print(num3)
            num3 += 1
        } while num3 <= 12
        
        // 6.switch文
        /*
         switch 式 {
            case 値1:
                処理A
            case 値2,値3:
                処理B
            default:
                処理C
         
            処理で何もしない場合はbreakと書く必要がある
         }
        */
        
        for i in 0...10 {
            switch i {
            case 0:
                print("処理を開始")
            case 10:
                print("処理を終了")
            default:
                print(i)
            }
        }
        
        
        // C3 -- 関数
        print(arc4random()) // 0 ~ 2**31-1 の乱数
        print(arc4random()%10) // 0~9 の乱数
        
        // 1.関数の定義
        /*
         func 関数名(引数名: 引数の型) -> 戻り値の型 {
            処理
            return 戻り値
         }
         
         呼び出す時は 関数名(引数名: 値) と書く
         デフォルト値を設定する場合は (引数名: 引数の型 = デフォルト値)
         引数ラベル >> 関数内で使う名前と呼び出し時に使う名前(引数ラベルという)を変える
         引数ラベルを_とするとラベルをなしにできる >> (引数ラベル 引数名: 引数の型)
        */
        func echo(_ word1: String, toshi age: Int32) {
            print(word1,age,"番")
        }
        
        echo("こんにちは",toshi:32)
        
        // 2. 関数名の表記
        func hello(){
            print(#function) //関数名
            print(#file)  //ファイル名
            print(#column) //行数
            print(#line)  //行内の位置
        }
        
        hello()
        
        // 3. guard
        /*
         関数などでエラーが発生しないようにするための文章。trueの処理がないif文のようなもの
         guard 関数を継続する条件 else {
            関数を終わらせる処理
         }
         関数の他にもfor文で使える
         */
        func evenOrOdd(num4: UInt32=10) -> String {
            guard num4 != 0 else{
                return "０です"
            }
            let ans = num4 % 2 == 1 ? "奇数" : "偶数"
            return ans
        }
        for _ in 0...5{
            print(evenOrOdd(num4: arc4random_uniform(10)))
        }
        
        // 4.defer
        for i in ["結衣","さっちゃん","琴葉"] {
            defer {
                print(i,"この街を守る！")
            }
            if i == "結衣" {
                print(i,"なんでさー")
            } else if i == "さっちゃん" {
                print(i,"うんこか！")
                continue
            }
            defer {
                // continue break や関数のreturn で抜けた場合はそれ以降のdeferは実行されない
                // defer は後ろにあるものから順に実行される
                print(i,"斎藤をやっつけろ")
            }
            if i == "琴葉" {
                print(i,"ゲームクリヤー")
            }
        }
        
        // 5.クロージャー
        /*
         { (引数名: 引数の型) -> 戻り値の型 in
            処理
         }
         */
        // クロージャーは難しいけど便利なので復習すること
        
        
        // C5 -- 配列
        // 配列
        let array = ["クール","キュート","パッション"]
        let array2: [Int] = [32,45,67]
        // 他にもいくつか宣言の仕方がある
        print(array.count)
        print(array2[0])
        
        // 連続整数の配列
        let array3 = [Int](-1...4)
        print(array3)
        print(array3.first!,array3.last!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

