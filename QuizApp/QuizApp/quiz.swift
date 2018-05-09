//
//  quiz.swift
//  QuizApp
//
//  Created by 鈴木健一 on 2018/05/09.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

// クラスオブジェクトの設計図
class Quiz: NSObject{
    
    // クイズ１つの問題がどんな値を扱うか宣言
    var text: String
    var option1: String
    var option2: String
    var option3: String
    var answer: String
    
    // Initializer (初期化処理)
    init(text: String,option1:String,option2:String,option3:String,answer:String){
        self.text = text
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.answer = answer
    }
    
    // シャッフするアルゴリズム(フィッシャー＆イェーツ・アルゴリズム)
    class func shuffle(quizArray: [Quiz]) -> [Quiz] {
        var quiz = quizArray
        var shuffledQuizArray: [Quiz] = []
        for _ in 0..<quiz.count {
            let index = Int(arc4random_uniform(UInt32(quiz.count)))
            shuffledQuizArray.append(quiz[index])
            quiz.remove(at: index)
        }
    return shuffledQuizArray
    }
}
