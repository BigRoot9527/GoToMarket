//
//  NoteTableViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

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

class NoteTableViewCell: UITableViewCell {
    
    //MARK: ChangingCell
    @IBOutlet weak var topCellView: UIView!
    @IBOutlet weak var topCellViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCellView: UIView!
    
    //MARK: TopViewOutlets
    @IBOutlet weak var topFinishButton: UIButton!
    @IBOutlet weak var topItemNameLabel: UILabel!
    @IBOutlet weak var topSellPriceLabel: UILabel!
    @IBOutlet weak var topBuyingAmountLabel: UILabel!
    //TODO 上次購買價
    
    //MARK: BottomViewOutlets
    @IBOutlet weak var bottomFinishButton: UIButton!
    @IBOutlet weak var bottomItemNameLabel: UILabel!
    @IBOutlet weak var bottomDeleteButton: UIButton!
    @IBOutlet weak var bottomSellPriceLabel: UILabel!
    @IBOutlet weak var bottomNewRealPriceLabel: UILabel!
    @IBOutlet weak var bottomLastRealPriceLabel: UILabel!
    @IBOutlet weak var bottomPriceInfoButton: UIButton!
    @IBOutlet weak var bottomBuyingAmountTextField: UITextField!
    @IBOutlet weak var bottomBuyingAmountStepper: UIStepper!
    
    weak var delegate: NoteTableViewCellDelegate?
    
    let topCellOriginHeight: CGFloat = 100
    let bottomCellHeight: CGFloat = 200
    
    var isOpened: Bool = true {
        
        didSet {
            changingCell()
        }
    }

    func setupCellView(
        showingOpened: Bool,
        showingTop: Bool = false,
        buttonShowFinished: Bool,
        itemName: String,
        truePrice: Double,
        multipler: Double,
        lastTruePrice: Double,
        buyingAmount: Int16,
        buttonsDelegate: NoteTableViewCellDelegate,
        bottomTextFieldDelegate: UITextFieldDelegate) {
        
        isOpened = showingOpened
        
        topFinishButton.isSelected = buttonShowFinished
        topItemNameLabel.text = itemName
        topSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(
            fromTruePrice: truePrice,
            andMultipler: multipler)
        topBuyingAmountLabel.text = String(buyingAmount)
        
        bottomFinishButton.isSelected = buttonShowFinished
        bottomItemNameLabel.text = itemName
        bottomSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(
            fromTruePrice: truePrice,
            andMultipler: multipler)
        bottomNewRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(
            fromTruePrice: truePrice)
        bottomLastRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(
            fromTruePrice: lastTruePrice)
        bottomBuyingAmountTextField.text = String(buyingAmount)
        
        bottomBuyingAmountTextField.delegate = bottomTextFieldDelegate
        
        delegate = buttonsDelegate
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    
    private func changingCell() {
        
        topCellViewHeightConstraint.constant = isOpened ? 0 : topCellOriginHeight 
        
        bottomCellView.alpha = isOpened ? 1 : 0
        
        self.layoutIfNeeded()
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
