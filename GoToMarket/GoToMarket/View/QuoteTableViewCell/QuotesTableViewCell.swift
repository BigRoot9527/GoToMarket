//
//  QuoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuotesTableViewCell: UITableViewCell {
    
    var inBuyingChart: Bool = false {
        didSet {
            updateIndicator()
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var buyingIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateIndicator() {
        if inBuyingChart {
            buyingIndicatorImageView.isHidden = false
        } else {
            buyingIndicatorImageView.isHidden = true
        }
        
    }
    

}
