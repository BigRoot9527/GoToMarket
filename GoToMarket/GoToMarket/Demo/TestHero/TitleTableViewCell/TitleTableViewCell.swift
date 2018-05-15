//
//  TitleTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/14.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Hero

class TitleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleTrasitionView: UIView!
    
    @IBOutlet weak var titleNameLabel: UILabel!
    
    func setup() {
        self.titleTrasitionView.layer.cornerRadius = 15
        self.titleTrasitionView.layer.masksToBounds = true
        self.titleTrasitionView.layer.shouldRasterize = true
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        print("aaa")
        
//        titleTrasitionView.hero.id = "titleCellView"
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
