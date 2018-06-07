//
//  QuoteSwitchViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuoteSwitchViewController: UIViewController {
    
    var switchControl = UIControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switchControl.frame = self.view.bounds
    }
    
    
    //MARK: - SwitchControl
    private func setup() {
        
        let segmentedControl = CustomSegmentedContrl(frame: self.view.bounds)
        
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
    
    
    @objc func onChangeOfSegment(_ sender:UIControl) {
        
        
        
    }
}
