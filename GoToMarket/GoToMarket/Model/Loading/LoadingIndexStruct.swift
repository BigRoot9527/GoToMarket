//
//  User.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/9.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum TaskKeys {
    
    case crop
    case pig
    case chicken
    
    func getUpdateDateKeyString() -> String {
        switch self {
        case .crop:
            return "Crop-Date"
        case .pig:
            return "Pig-Date"
        case .chicken:
            return "Chicken-Date"
        }
    }
    
    func getMarketKeyString() -> String {
        switch self {
        case .crop:
            return "Crop-Market"
        case .pig:
            return "Pig-Market"
        case .chicken:
            return "Chicken-Market"
        }
    }
    
    func getMarketsOfItem() -> [String] {
        switch self {
        case .crop:
            return CropMarkets.allValues.map{ $0.rawValue.capitalized }
        default:
            return [ "地區一", " 地區二", "地區三" ]
        }
    }
    
    func getTaskItemTypeName() -> String {
        switch self {
        case .crop:
            return GoToMarketConstant.itemTypeNameForCrops
        default:
            return "喵喵"
        }
    }
    
    static let allCases = [crop, pig, chicken]
}
