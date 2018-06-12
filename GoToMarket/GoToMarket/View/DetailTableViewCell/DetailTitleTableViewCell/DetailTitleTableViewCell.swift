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
    @IBOutlet weak var titleBackgroundView: UIView!

    @IBOutlet weak var backgroundToContentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundToContentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundToContentBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundToContentTrailingConstraint: NSLayoutConstraint!

    //Input
    var isInCartInput: Bool? {
        didSet {
            setUI()
        }
    }

    var compressRate: CGFloat = 0 {
        didSet {
            showTransformAnimation(rate: compressRate)
        }
    }

    var isFruit: Bool = false {
        didSet {
            changeBackgroundColor()
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

        titleBackgroundView.clipsToBounds = true
    }

    private func showTransformAnimation(rate: CGFloat) {

        let fixedRate = rate < 0 ? 0 : rate > 1 ? 1 : rate

        let transformingHeight = 5 * fixedRate

        let transformingWidth = 15 * fixedRate

        let transformingRadius = 10 * fixedRate

        backgroundToContentTopConstraint.constant = transformingHeight
        backgroundToContentBottomConstraint.constant = transformingHeight
        backgroundToContentLeadingConstraint.constant = transformingWidth
        backgroundToContentTrailingConstraint.constant = transformingWidth

        titleBackgroundView.layer.cornerRadius = transformingRadius

        self.layoutIfNeeded()
    }

    private func changeBackgroundColor() {
        titleBackgroundView.backgroundColor = isFruit ?
            UIColor(named: GotoMarketColors.FruitCellBackground) :
            UIColor(named: GotoMarketColors.VegeCellBackground)
    }
}
