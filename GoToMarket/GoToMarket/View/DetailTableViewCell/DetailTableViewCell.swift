//
//  DetailTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol DetailTableViewCellDelegate: class {
    func priceInfoButtonTapped(sender: UIButton)
    func buyingButtonTapped(sender: UIButton, inChart: Bool)
    func changeWeightButtonTapped(sender: UIButton, showingInKg: Bool)
    func dropDownButtonTapped(sender: UIButton, isExpended: Bool)
}

class DetailTableViewCell: UITableViewCell {
    
    weak var delegate: DetailTableViewCellDelegate?
    
    enum wikiLabelState {
        case none
        case expended
        case folded
        
        func getTranslationY() -> CGFloat {
            switch self {
            case .expended:
                return 155.0
            case .folded:
                return 0.0
            case .none:
                return 0.0
            }
        }
        
        func getRotationAngle() -> CGFloat {
            switch self {
            case .expended:
                return CGFloat.pi
            case .folded:
                return 0
            case .none:
                return 0
            }
        }
    }
    var wikiState: wikiLabelState = .folded {
        didSet {
            updateWikiUI()
        }
    }
    var isKG: Bool = true {
        didSet {
            updateWeightTypeLabel()
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
    
    private func updateWeightTypeLabel() {
        if isKG {
            detailWeightTypeLabel.text = WeightType.KG.rawValue
        } else {
            detailWeightTypeLabel.text = WeightType.TG.rawValue
        }
    }
    
    private func updateWikiUI() {
        switch wikiState {
        case .none:
            detailDropDownButton.isHidden = true
            detailWikiScrollView.isHidden = true
        case .expended:
            detailDropDownButton.isHidden = false
            detailWikiScrollView.isHidden = false
            dropDownAnimation()
        case .folded:
            detailDropDownButton.isHidden = false
            detailWikiScrollView.isHidden = false
            dropDownAnimation()
        }
    }
    
    private func dropDownAnimation() {
        
        UIView.animate(withDuration: GoToMarketConstant.detailDropDownDuration) {
            
            self.detailWikiScrollView.transform = CGAffineTransform.init(
                translationX: 0.0,
                y: self.wikiState.getTranslationY())
            
            self.detailQuoteInfoView.transform = CGAffineTransform.init(
                translationX: 0.0,
                y: self.wikiState.getTranslationY())
            
            self.detailHistoryView.transform = CGAffineTransform.init(
                translationX: 0.0,
                y: self.wikiState.getTranslationY())
            
            self.detailDropDownButton.transform = CGAffineTransform.init(
                rotationAngle: self.wikiState.getRotationAngle())
        }
        
    }
    
    @IBAction func didTapDropDownButton(_ sender: UIButton) {
        switch wikiState {
        case .expended:
            wikiState = .folded
            delegate?.dropDownButtonTapped(sender: sender, isExpended: false)
        case .folded:
            wikiState = .expended
            delegate?.dropDownButtonTapped(sender: sender, isExpended: true)
        default:
            return
        }
    }
    
    
    //MARK: Delegate
    @IBAction func didTapBuyingButton(_ sender: UIButton) {
        
        detailBuyingButton.isSelected = !detailBuyingButton.isSelected
        
        delegate?.buyingButtonTapped(sender: sender,
                                     inChart: detailBuyingButton.isSelected)
    }
    
    
    @IBAction func didTapPriceInfoButton(_ sender: UIButton) {
        delegate?.priceInfoButtonTapped(sender: sender)
    }
    
    @IBAction func didTapChangeWeightButton(_ sender: UIButton) {
        
        var angle = CGFloat.pi
        
        if isKG {
            angle = 0
        }
        
        isKG = !isKG
        
        UIView.animate(withDuration: 0.3) {
            self.detailChangeWeightButton.transform = CGAffineTransform.init(rotationAngle: angle)
        }
        delegate?.changeWeightButtonTapped(sender: sender, showingInKg: isKG)
    }
    
    

}
