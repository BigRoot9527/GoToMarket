//
//  DetailRowType.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import UIKit

enum DetailRowType {
    case title
    case intro
    case quotes
    case history
    case empty
    
    func heightForRow() -> CGFloat {
        switch self {
        case .title:
            return GoToMarketConstant.quotesRowHeight
        case .intro:
            return UITableViewAutomaticDimension
        case .quotes:
            return 200.0
        case .history:
            return 290
        case .empty:
            return 5.0
        }
    }
}
