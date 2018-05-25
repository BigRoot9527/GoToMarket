//
//  DetailTableViewCellDelegate.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol DetailTableViewCellDelegate: class {
    func priceInfoButtonTapped(sender: UIButton)
    func buyingButtonTapped(sender: UIButton)
    func changeWeightButtonTapped(sender: UIButton, fromCell: DetailQuotesTableViewCell)
}
