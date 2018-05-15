//
//  DetailTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/14.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Hero

class HeroDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trasitionView: UIView!
    @IBOutlet weak var secondNamelabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.blue
//        trasitionView.hero.id = "titleCellView"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
