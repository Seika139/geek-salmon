//
//  ViewController.swift
//  QuizApp
//
//  Created by 鈴木健一 on 2018/05/09.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //変数宣言と初期化
    var point: Int = 0
    var quizNumber: Int = 0
    var quizArray: [Quiz] = []

    // Storyboard上のパーツについて宣言
    @IBOutlet var quizNumberLabel: UILabel!
    @IBOutlet var quizTextView: UITextView!
    @IBOutlet var option1Button: UIButton!
    @IBOutlet var option2Button: UIButton!
    @IBOutlet var option3Button: UIButton!
    
    // 画面起動時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // クイズのセットアップ
        setupQuiz()
        // クイズ番号、クイズ、各選択肢の表示
        showQuiz()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupQuiz() {
        let quiz1 = Quiz(text:"スリラーバーグに上陸してナミたちが出会ったケルベロスには犬以外の動物の頭部もあったが、その動物は何？", option1:"猫",option2:"狐",option3:"狼",answer:"狐")
        let quiz2 = Quiz(text:"ジャヤでモンブラン・クリケットたちにメリー号を改造してもらい空島へと旅立とうとする麦わらの一味だったが、ルフィの遅刻のせいで出発がギリギリになってしまった。その遅刻の理由は何？", option1:"ベラミーとの戦いが長引いたから",option2:"カブトムシを捕まえていたから",option3:"寝ていたから",answer:"カブトムシを捕まえていたから")
        let quiz3 = Quiz(text:"アッパーヤードで行われる４つの試練の内、もっとも生存率が低いのはどの試練？", option1:"鉄の試練",option2:"沼の試練",option3:"玉の試練",answer:"鉄の試練")
        let quiz4 = Quiz(text:"ウォーターセブンでロビンがCP9に連れ去られた時、最後に一緒にいたのはだれ？", option1:"サンジ",option2:"ウソップ",option3:"チョッパー",answer:"チョッパー")
        let quiz5 = Quiz(text:"パンクハザードにてモネを殺害したのは誰？", option1:"シーザー・クラウン",option2:"ゾロ",option3:"たしぎ",answer:"シーザー・クラウン")
        
        // quizArrayに問題を追加
        quizArray.append(quiz1)
        quizArray.append(quiz2)
        quizArray.append(quiz3)
        quizArray.append(quiz4)
        quizArray.append(quiz5)
        
        // quizArrayをシャッフルする
        quizArray = Quiz.shuffle(quizArray: quizArray)
    }

    func showQuiz() {
        // クイズ番号、クイズ、各選択肢の表示
        quizNumberLabel.text = "問題. " + String(quizNumber + 1)
        quizTextView.text = quizArray[quizNumber].text
        option1Button.setTitle(quizArray[quizNumber].option1, for: .normal)
        option2Button.setTitle(quizArray[quizNumber].option2, for: .normal)
        option3Button.setTitle(quizArray[quizNumber].option3, for: .normal)
    }
    
    func resetQuiz() {
        point = 0
        quizNumber = 0
        self.quizArray = Quiz.shuffle(quizArray: self.quizArray)
        self.showQuiz()
    }
    
    // クイズをアップデート
    func updateQuiz(){
        // 問題番号を更新
        quizNumber += 1
        
        // もし問題を解き終えたら、アラートを出して結果を表示
        if quizNumber == quizArray.count {
            let alertText = "\(quizArray.count)問中、\(point)問正解です。"
            let alertController = UIAlertController(title: "結果", message: alertText, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.resetQuiz()
            })
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
        } else {
            // 最終問題以外では次の問題を表示
            showQuiz()
        }
    }

    // 選択肢1が押された時の処理
    @IBAction func selectOption1() {
        // ボタン内の文と、設定していた答えが一致しているかを確認
        if option1Button.titleLabel?.text == quizArray[quizNumber].answer {
            print("正解")
            // ポイント追加
            point += 1
        } else {
            print("不正解")
        }
        // 次の問題へ
        updateQuiz()
    }
    
    // 選択肢2が押された時の処理
    @IBAction func selectOption2() {
        // ボタン内の文と、設定していた答えが一致しているかを確認
        if option2Button.titleLabel?.text == quizArray[quizNumber].answer {
            print("正解")
            // ポイント追加
            point += 1
        } else {
            print("不正解")
        }
        // 次の問題へ
        updateQuiz()
    }
    
    // 選択肢3が押された時の処理
    @IBAction func selectOption3() {
        // ボタン内の文と、設定していた答えが一致しているかを確認
        if option3Button.titleLabel?.text == quizArray[quizNumber].answer {
            print("正解")
            // ポイント追加
            point += 1
        } else {
            print("不正解")
        }
        // 次の問題へ
        updateQuiz()
    }
}

