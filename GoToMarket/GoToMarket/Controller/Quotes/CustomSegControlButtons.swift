//
//  CustomSegControlButtons.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/10.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class CustomSegCrlButton {
    
    let title: String
    let normalBackgroundColor: UIColor?
    let selectedBackgroundColor: UIColor?
    let normalTextColor: UIColor?
    let selectedTextColor: UIColor?
    
    var buttonItem = UIButton()
    
    init(
        titleText: String,
        normalBackgroundColor nmBgColor: UIColor?,
        selectedBackgroundColor slBgColor: UIColor?,
        normalTextColor nmTxColor: UIColor?,
        selectedTextColor slTxColor: UIColor?) {
        
        self.title = titleText
        self.normalBackgroundColor = nmBgColor
        self.selectedBackgroundColor = slBgColor
        self.normalTextColor = nmTxColor
        self.selectedTextColor = slTxColor
        
        self.buttonItem = creatButton()
    }
    
    func didSelected() {
        
        buttonItem.setTitleColor(selectedTextColor, for: .normal)
        buttonItem.backgroundColor = selectedBackgroundColor
    }
    
    func unSelected() {
        
        buttonItem.setTitleColor(normalTextColor, for: .normal)
        buttonItem.backgroundColor = normalBackgroundColor
    }
    
    
    private func creatButton() -> UIButton {
        
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang TC", size: 18)
        button.setTitleColor(normalTextColor, for: .normal)
        button.backgroundColor = normalBackgroundColor
        
        return button
    }
    
}
