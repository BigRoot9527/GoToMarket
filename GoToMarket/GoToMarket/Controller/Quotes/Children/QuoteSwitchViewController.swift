//
//  QuoteSwitchViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol QuoteSwitchViewControllerDelegate: class {
    
    func switchTypeButtonTapped(sender: UIViewController, selectedIndex: Int) -> Void
}

class QuoteSwitchViewController: UIViewController {
    
    private var switchControl = UIControl()
    
    weak var delegate: QuoteSwitchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - SwitchControl
    private func setup() {
        
        let totalButton = CustomSegCrlButton(
            titleText: GoToMarketConstant.quoteListsAllText,
            normalBackgroundColor: UIColor.white,
            selectedBackgroundColor: UIColor.white,
            normalTextColor: UIColor(named: GotoMarketColors.unSelectText),
            selectedTextColor: UIColor(named: GotoMarketColors.MainTitleText))
        
        let vegeButton = CustomSegCrlButton(
            titleText: GoToMarketConstant.quoteListsVegeText,
            normalBackgroundColor: UIColor.white,
            selectedBackgroundColor: UIColor(named: GotoMarketColors.VegeCellBackground),
            normalTextColor: UIColor(named: GotoMarketColors.unSelectText),
            selectedTextColor: UIColor(named: GotoMarketColors.MainTitleText))
        
        let fruitButton = CustomSegCrlButton(
            titleText: GoToMarketConstant.quoteListsFruitText,
            normalBackgroundColor: UIColor.white,
            selectedBackgroundColor: UIColor(named: GotoMarketColors.FruitCellBackground),
            normalTextColor: UIColor(named: GotoMarketColors.unSelectText),
            selectedTextColor: UIColor(named: GotoMarketColors.MainTitleText))
        
        let segmentedControl = CustomSegmentedContrl(
            frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 50),
            selectorColor: UIColor.darkGray,
            customSegButtons: [totalButton, vegeButton, fruitButton])
        
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
    
        self.switchControl = segmentedControl
        self.view.addSubview(switchControl)
    }
    
    
    @objc func onChangeOfSegment(_ sender:CustomSegmentedContrl) {
        
        delegate?.switchTypeButtonTapped(sender: self, selectedIndex: sender.selectedSegmentIndex)
    }
}
