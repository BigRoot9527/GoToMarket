//
//  DetailTitleTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class DetailTitleTableViewCell: UITableViewCell {
    //TODO: activity indicator when loading Text and image
    //TODO: placeHoulder image when no image (no text is done by remove button)
    //TODO: maybe aspect fit is better

    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailBuyingButton: UIButton!
    
    var isInCartInput: Bool? {
        didSet{
            setUI()
        }
    }
    
    weak var delegate: DetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    @IBAction func didTapBuyingButton(_ sender: UIButton) {
        
        detailBuyingButton.isSelected = !detailBuyingButton.isSelected
        
        delegate?.buyingButtonTapped(sender: sender)
    }
    
    private func setUI() {
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let bool = isInCartInput {
            
            detailBuyingButton.isSelected = bool
        }
    }
    
}
