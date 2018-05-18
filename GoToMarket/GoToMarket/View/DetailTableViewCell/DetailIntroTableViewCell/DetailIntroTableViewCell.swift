//
//  DetailIntroTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class DetailIntroTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var detailWikiLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUI() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

}
