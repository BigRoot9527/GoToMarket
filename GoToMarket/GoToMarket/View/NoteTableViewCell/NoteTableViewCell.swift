//
//  NoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import FoldingCell

protocol NoteTableViewCellDelegate: class {
    
    func didTapFinishedButton(
        sender: UIButton,
        fromCell: NoteTableViewCell)
    
    func didTapDeleteButton(
        sender: UIButton,
        fromCell: NoteTableViewCell)
    
    func didTapStepper(
        sender: UIStepper,
        fromCell: NoteTableViewCell)
    
    func didTapPriceInfoButton(
        sender: UIButton,
        fromCell: NoteTableViewCell)
}

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
    
    weak var delegate: NoteTableViewCellDelegate?

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
        let durations = [0.3, 0.3] // timing animation for each view
        return durations[itemIndex]
    }
    
    
    //MARK: IBActions
    
    @IBAction func didTapTopIsFinishedButton(_ sender: UIButton) {
        delegate?.didTapFinishedButton(sender: sender, fromCell: self)
    }
    
    
    @IBAction func didTapBottomIsFinishedButton(_ sender: UIButton) {
        delegate?.didTapFinishedButton(sender: sender, fromCell: self)
    }
    
    @IBAction func didTapBottomDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(sender: sender, fromCell: self)
    }
    
    @IBAction func didTapBottomPriceInfoButton(_ sender: UIButton) {
        delegate?.didTapPriceInfoButton(sender: sender, fromCell: self)
    }
    
    @IBAction func didTapBottomStepper(_ sender: UIStepper) {
        delegate?.didTapStepper(sender: sender, fromCell: self)
    }
    
    
}
