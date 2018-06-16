//
//  FoodTableViewCell.swift
//  SpmpleTableView
//
//  Created by 鈴木健一 on 2018/05/10.
//  Copyright © 2018年 seika. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var foodNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
