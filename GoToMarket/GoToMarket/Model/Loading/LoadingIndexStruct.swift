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
    func getKeyString() -> String {
        switch self {
        case .crop:
            return "GoToMarket-Crop"
        case .pig:
            return "GoToMarket-Pig"
        case .chicken:
            return "GoToMarket-Chicken"
        }
    }
    static let allCases = [crop]
}

protocol Task {
    var ApiType: TaskKeys { get set }
}

struct CropTask: Task {
    var ApiType: TaskKeys
    var market: CropMarkets
    var requestType: CropQueryType
    
    var createRequest: CropRequest {
        return CropRequest(cropRequestType: requestType, cropMarket: market)
    }
    
}
