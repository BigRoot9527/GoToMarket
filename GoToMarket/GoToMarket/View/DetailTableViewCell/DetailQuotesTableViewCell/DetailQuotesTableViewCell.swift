//
//  DetailQuotesTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class DetailQuotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailQuoteInfoView: UIView!
    @IBOutlet weak var detailSellPriceLabel: UILabel!
    @IBOutlet weak var detailRealPriceLabel: UILabel!
    @IBOutlet weak var detailUpdateTimeLabel: UILabel!
    @IBOutlet weak var detailMarketLabel: UILabel!
    @IBOutlet weak var detailPriceInfoButton: UIButton!
    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    
    
    weak var delegate: DetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapPriceInfoButton(_ sender: UIButton) {
        delegate?.priceInfoButtonTapped(sender: sender)
    }
    
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {
        
        delegate?.changeWeightButtonTapped(sender: sender, fromCell: self)
        
    }
    
}
