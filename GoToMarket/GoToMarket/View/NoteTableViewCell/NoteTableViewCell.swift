//
//  NoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import FoldingCell

class NoteTableViewCell: FoldingCell {
    
    
    //MARK: FoldingCell
    @IBOutlet weak var topCellView: RotatedView!
    @IBOutlet weak var topCellViewToContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCellView: UIView!
    @IBOutlet weak var bottomCellViewToContentViewTopConstraint: NSLayoutConstraint!
    
    //MARK: TopViewOutlets
    @IBOutlet weak var topFinishButton: UIButton!
    @IBOutlet weak var topItemNameLabel: UILabel!
    @IBOutlet weak var topCellPriceLabel: UILabel!
    @IBOutlet weak var topBuyingAmountLabel: UILabel!
    @IBOutlet weak var topWeightTypeLabel: UILabel!
    
    //MARK: BottomViewOutlets
    @IBOutlet weak var bottomFinishButton: UIButton!
    @IBOutlet weak var bottomItemNameLabel: UILabel!
    @IBOutlet weak var bottomDeleteButton: UIButton!
    @IBOutlet weak var bottomSellPriceLabel: UILabel!
    @IBOutlet weak var bottomNewRealPriceLabel: UILabel!
    @IBOutlet weak var bottomLastRealPriceLabel: UILabel!
    @IBOutlet weak var bottomPriceInfoButton: UIButton!
    @IBOutlet weak var bottomWeightTypeLabel: UILabel!
    @IBOutlet weak var bottomBuyingAmountTextField: UITextField!
    @IBOutlet weak var bottomBuyingAmountStepper: UIStepper!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
////
//        super.containerView = bottomCellView
//        super.foregroundView = topCellView
//        super.foregroundViewTop = topCellViewToContentViewTopConstraint
//        super.containerViewTop = bottomCellViewToContentViewTopConstraint
//        containerView = bottomCellView
//        foregroundView = topCellView
//        foregroundViewTop = topCellViewToContentViewTopConstraint
//        containerViewTop = bottomCellViewToContentViewTopConstraint
////
//////        fatalError("init(coder:) has not been implemented")
//        
//    }
//    
    override func awakeFromNib() {
        
        self.containerView = bottomCellView
        self.foregroundView = topCellView
        self.foregroundViewTop = topCellViewToContentViewTopConstraint
        self.containerViewTop = bottomCellViewToContentViewTopConstraint
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.25, 0.25] // timing animation for each view
        return durations[itemIndex]
    }

}
