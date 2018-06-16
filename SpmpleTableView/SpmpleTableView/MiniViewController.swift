//
//  MiniViewController.swift
//  SpmpleTableView
//
//  Created by 鈴木健一 on 2018/05/10.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class MiniViewController: UIViewController {

    var selectedName: String = ""
    @IBOutlet var selectedNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedNameLabel.text = selectedName

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
