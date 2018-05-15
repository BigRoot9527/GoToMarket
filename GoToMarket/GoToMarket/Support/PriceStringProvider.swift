//
//  PriceStringProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum WeightType: String {
    
    case KG = "(每公斤)"
    
    case TG = "(每台斤)"
    
}

class PriceStringProvider {
    
    class func getSellPriceString(
        fromTruePrice truePrice: Double,
        andMultipler mutipler: Double,
        inWeightType type: WeightType) -> String {
        
        switch type {
        case .KG:
            let count = truePrice * mutipler
            return String(format: "%.1f", count)
        case .TG:
            let count = truePrice * mutipler / 0.6
            return String(format: "%.1f", count)
        }
    }
    
    class func getTruePriceString(
        fromTruePrice truePrice: Double,
        inWeightType type: WeightType) -> String {
        
        switch type {
        case .KG:
            let count = truePrice
            return String(format: "%.1f", count)
        case .TG:
            let count = truePrice / 0.6
            return String(format: "%.1f", count)
        }
    }

    
    
    
}
