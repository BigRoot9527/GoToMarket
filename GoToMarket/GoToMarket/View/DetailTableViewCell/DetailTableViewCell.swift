//
//  DetailTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    var inBuyingChart: Bool = false {
        didSet {
            updateButton()
        }
    }

    
    @IBOutlet weak var detailWikiImageView: UIImageView!
    @IBOutlet weak var detailWikiLabel: UILabel!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailBuyingButton: UIButton!
    
    @IBOutlet weak var detailSellPriceLabel: UILabel!
    @IBOutlet weak var detailRealPriceLabel: UILabel!
    @IBOutlet weak var detailUpdateTimeLabel: UILabel!
    @IBOutlet weak var detailMarketLabel: UILabel!
    @IBOutlet weak var detailPriceInfoButton: UIButton!
    @IBOutlet weak var detailWeightTypeLabel: UILabel!
    @IBOutlet weak var detailChangeWeightButton: UIButton!
    
    @IBOutlet weak var detailHistoryPriceView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUI() {
    }
    
    private func updateButton() {
        //TODO
    }
    
    @IBAction func didTapBuyingButton(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapPriceInfoButton(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapChangeWeightButton(_ sender: UIButton) {
    }
    
    
    

}
