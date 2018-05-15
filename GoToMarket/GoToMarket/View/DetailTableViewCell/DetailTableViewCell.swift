//
//  DetailTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol HeroDetailTableViewCellDelegate: class {
    func priceInfoButtonTapped()
    func buyingButtonTapped()
    func changeWeightButtonTapped()
    func dropDownButtonTapped()
}

class DetailTableViewCell: UITableViewCell {
    
    weak var delegate: HeroDetailTableViewCell?
    
    var inBuyingChart: Bool = false {
        didSet {
            updateBuyingButton()
        }
    }
    
    var isExpended: Bool = false {
        didSet {
            showingAnimate()
        }
    }

    
    @IBOutlet weak var detailWikiImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDropDownButton: UIButton!
    @IBOutlet weak var detailBuyingButton: UIButton!
    
    @IBOutlet weak var detailWikiScrollView: UIScrollView!
    @IBOutlet weak var detailWikiLabel: UILabel!
    
    
    @IBOutlet weak var detailQuoteInfoView: UIView!
    @IBOutlet weak var detailSellPriceLabel: UILabel!
    @IBOutlet weak var detailRealPriceLabel: UILabel!
    @IBOutlet weak var detailUpdateTimeLabel: UILabel!
    @IBOutlet weak var detailMarketLabel: UILabel!
    @IBOutlet weak var detailPriceInfoButton: UIButton!
    @IBOutlet weak var detailWeightTypeLabel: UILabel!
    @IBOutlet weak var detailChangeWeightButton: UIButton!
    
    
    @IBOutlet weak var detailHistoryView: UIView!
    @IBOutlet weak var detailHistoryPriceContentView: UIView!

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
    
    private func updateBuyingButton() {
        //TODO
    }
    
    private func showingAnimate() {
        UIView.animate(withDuration: 0.3) {
            if self.isExpended {
                self.detailWikiScrollView.transform = CGAffineTransform.init(translationX: 0.0, y: 155)
                self.detailQuoteInfoView.transform = CGAffineTransform.init(translationX: 0.0, y: 155)
                self.detailHistoryView.transform = CGAffineTransform.init(translationX: 0.0, y: 155)
                self.detailDropDownButton.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
            } else {
                self.detailWikiScrollView.transform = CGAffineTransform.init(translationX: 0.0, y: -155)
                self.detailQuoteInfoView.transform = CGAffineTransform.init(translationX: 0.0, y: -155)
                self.detailHistoryView.transform = CGAffineTransform.init(translationX: 0.0, y: -155)
                self.detailDropDownButton.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
            }
        }
    }
    
    @IBAction func didTapBuyingButton(_ sender: UIButton) {
        delegate
    }
    
    
    @IBAction func didTapPriceInfoButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.detailChangeWeightButton.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        }
    }
    
    @IBAction func didTapChangeWeightButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapDropDownButton(_ sender: UIButton) {
    }
    
    

}
