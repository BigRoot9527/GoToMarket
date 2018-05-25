//
//  QuoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import SwipeCellKit

class QuotesTableViewCell: SwipeTableViewCell {
    
    //Input
    var inBuyingChart: Bool = false {
        didSet {
            updateIndicator()
        }
    }
    //Input
    var priceIndicator: Double? {
        didSet {
            updatePriceMark()
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var buyingIndicatorImageView: UIImageView!
    @IBOutlet weak var priceMarkImageView: UIImageView!
    
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
    
    private func updatePriceMark() {
        
        guard let rate = priceIndicator else { return }
        
        switch rate {
        
        case ..<0.7:
            priceMarkImageView.image = #imageLiteral(resourceName: "down3")
        case 0.7..<0.9:
            priceMarkImageView.image = #imageLiteral(resourceName: "down2")
        case 0.9..<1:
            priceMarkImageView.image = #imageLiteral(resourceName: "down1")
        case 1..<1.000001 :
            priceMarkImageView.image = #imageLiteral(resourceName: "equal")
        case 1.000001..<1.1:
            priceMarkImageView.image = #imageLiteral(resourceName: "up1")
        case 1.1 ..< 1.3:
            priceMarkImageView.image = #imageLiteral(resourceName: "up2")
        default:
            priceMarkImageView.image = #imageLiteral(resourceName: "up3")
        }
    }
}
