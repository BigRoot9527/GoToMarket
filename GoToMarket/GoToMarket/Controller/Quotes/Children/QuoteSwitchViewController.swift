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
        
        let segmentedControl = CustomSegmentedContrl(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        segmentedControl.backgroundColor = .white
        segmentedControl.commaSeperatedButtonTitles = GoToMarketConstant.quoteListsChineseText
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.textColor = UIColor.red
        segmentedControl.selectorTextColor = UIColor.blue
        segmentedControl.isUnderLinerNeeded = true
        
        self.switchControl = segmentedControl
        self.view.addSubview(switchControl)
    }
    
    
    @objc func onChangeOfSegment(_ sender:CustomSegmentedContrl) {
        
        delegate?.switchTypeButtonTapped(sender: self, selectedIndex: sender.selectedSegmentIndex)
    }
}
