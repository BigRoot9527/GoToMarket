//
//  QuoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import FoldingCell

class TestFoldingTableViewCell: FoldingCell {
    
    
    @IBOutlet weak var titleCellView: RotatedView!
    @IBOutlet weak var titleCellViewToContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailCellView: UIView!
    @IBOutlet weak var detailCellViewToContainerTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemNewPrice: UILabel!
    @IBOutlet weak var detailUpdateTimeLabel: UILabel!
    @IBOutlet weak var titleMarkButton: UIButton!
    @IBOutlet weak var detailMarkButton: UIButton!
    @IBOutlet weak var detailItemImageView: UIImageView!
    @IBOutlet weak var detailItemNameLabel: UILabel!
    @IBOutlet weak var detailIntroScrollView: UIScrollView!
    @IBOutlet weak var detailIntroLabel: UILabel!
    @IBOutlet weak var detailItemNewPrice: UILabel!
    @IBOutlet weak var detailHistoryContainerView: UIView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        super.containerView = detailCellView
//        super.foregroundView = titleCellView
//        super.foregroundViewTop = titleCellViewToContainerViewTopConstraint
//        super.containerViewTop = detailCellViewToContainerTopViewConstraint
//        containerView = detailCellView
//        foregroundView = titleCellView
//        foregroundViewTop = titleCellViewToContainerViewTopConstraint
//        containerViewTop = detailCellViewToContainerTopViewConstraint
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.foregroundView = titleCellView
//        self.foregroundViewTop = titleCellViewToContainerViewTopConstraint
//        self.containerView = detailCellView
//        self.containerViewTop = detailCellViewToContainerTopViewConstraint
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {

        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }

}
