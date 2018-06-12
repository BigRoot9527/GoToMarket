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

    // MARK: ChangingCell
    @IBOutlet weak var topCellView: UIView!
    @IBOutlet weak var topCellViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCellView: UIView!

    // MARK: TopViewOutlets
    @IBOutlet weak var topFinishButton: UIButton!
    @IBOutlet weak var topItemNameLabel: UILabel!
    @IBOutlet weak var topSellPriceLabel: UILabel!
    @IBOutlet weak var topBuyingAmountLabel: UILabel!
    @IBOutlet weak var topMarkerView: UIView!
    //TODO 上次購買價

    // MARK: BottomViewOutlets
    @IBOutlet weak var bottomFinishButton: UIButton!
    @IBOutlet weak var bottomItemNameLabel: UILabel!
    @IBOutlet weak var bottomDeleteButton: UIButton!
    @IBOutlet weak var bottomSellPriceLabel: UILabel!
    @IBOutlet weak var bottomNewRealPriceLabel: UILabel!
    @IBOutlet weak var bottomLastRealPriceLabel: UILabel!
    @IBOutlet weak var bottomPriceInfoButton: UIButton!
    @IBOutlet weak var bottomBuyingAmountTextField: UITextField!
    @IBOutlet weak var bottomBuyingAmountStepper: UIStepper!
    @IBOutlet weak var bottomMarkerView: UIView!

    weak var delegate: NoteTableViewCellDelegate?

    let topCellOriginHeight: CGFloat = 100
    let bottomCellHeight: CGFloat = 200

    var isOpened: Bool = true {
        didSet {
            changingCell()
        }
    }

    var isFinished: (Bool, TimeInterval) = (false, 0) {
        didSet {
            changingCollor(isFinished: isFinished.0, duration: isFinished.1)
        }
    }

    var isFruit: Bool = false {
        didSet {
            showingColor = isFruit ?
                UIColor(named: GotoMarketColors.FruitCellBackground) :
                UIColor(named: GotoMarketColors.VegeCellBackground)
            changeMarkerColor()
        }
    }

    private var showingColor: UIColor?

    func setupCellData(itemName: String,
                       sellingPrice: Double,
                       truePrice: Double,
                       lastTruePrice: Double,
                       buyingAmount: Int16) {

        topItemNameLabel.text = itemName
        topSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: sellingPrice)
        topBuyingAmountLabel.text = String(buyingAmount)

        bottomItemNameLabel.text = itemName
        bottomSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: sellingPrice)
        bottomNewRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(
            fromTruePrice: truePrice)
        bottomLastRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(
            fromTruePrice: lastTruePrice)
        bottomBuyingAmountTextField.text = String(buyingAmount)

    }

    func setupCellState(isFruitType: Bool,
                        showingOpened: Bool,
                        buttonShowFinished: Bool,
                        buttonsDelegate: NoteTableViewCellDelegate,
                        bottomTextFieldDelegate: UITextFieldDelegate,
                        bottomTextFieldTag: IndexPath) {

        isFruit = isFruitType
        isOpened = showingOpened
        topFinishButton.isSelected = buttonShowFinished
        bottomFinishButton.isSelected = buttonShowFinished
        isFinished = (buttonShowFinished, 0)
        bottomBuyingAmountTextField.delegate = bottomTextFieldDelegate
        delegate = buttonsDelegate
        bottomBuyingAmountTextField.tag = bottomTextFieldTag.row
        setupStepper()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    private func setupStepper() {

        let textFieldString = bottomBuyingAmountTextField.text ?? "0"

        bottomBuyingAmountStepper.value = Double(textFieldString) ?? 0.0
        bottomBuyingAmountStepper.minimumValue = 0
        bottomBuyingAmountStepper.maximumValue = 999
        bottomBuyingAmountStepper.stepValue = 1
        bottomBuyingAmountStepper.autorepeat = true
    }

    private func changingCell() {

        topCellViewHeightConstraint.constant = isOpened ? 0 : topCellOriginHeight

        bottomCellView.alpha = isOpened ? 1 : 0

        self.layoutIfNeeded()
    }

    private func changingCollor(isFinished: Bool, duration: TimeInterval) {

        UIView.animate(withDuration: duration) { [weak self] in

            if isFinished {

                self?.topCellView.backgroundColor = self?.showingColor

                self?.bottomCellView.backgroundColor = self?.showingColor

            } else {

                self?.topCellView.backgroundColor = GoToMarketColor.defaultNoteCellColor.color()

                self?.bottomCellView.backgroundColor = GoToMarketColor.defaultNoteCellColor.color()

            }
        }
    }

    private func changeMarkerColor() {

        topMarkerView.backgroundColor = showingColor
        bottomMarkerView.backgroundColor = showingColor
    }

    // MARK: IBActions
    @IBAction func didTapTopIsFinishedButton(_ sender: UIButton) {
        delegate?.didTapFinishedButton(sender: sender, fromCell: self)
        isFinished = (sender.isSelected, 0.3)
    }

    @IBAction func didTapBottomIsFinishedButton(_ sender: UIButton) {
        delegate?.didTapFinishedButton(sender: sender, fromCell: self)
        isFinished = (sender.isSelected, 0.3)
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

    @IBAction func textfieldChanged(_ sender: UITextField) {

        if
            let textFieldString = sender.text,
            let textFieldDouble = Double(textFieldString) {

            if textFieldDouble > 999 {

                sender.text = "999"

                bottomBuyingAmountStepper.value = 999
            }

            bottomBuyingAmountStepper.value = textFieldDouble

        } else {

            bottomBuyingAmountStepper.value =  0.0

        }
    }
}
