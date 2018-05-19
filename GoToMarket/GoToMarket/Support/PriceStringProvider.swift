//
//  PriceStringProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

class PriceStringProvider {
    
    class func getSellPriceString(
        fromTruePrice truePrice: Double,
        andMultipler mutipler: Double,
        inKg isKg: Bool) -> String {
        
        if isKg {
            let count = truePrice * mutipler
            return String(format: "%.1f", count)
        } else {
            let count = truePrice * mutipler / 0.6
            return String(format: "%.1f", count)
        }
    }
    
    class func getTruePriceString(
        fromTruePrice truePrice: Double,
        inKg isKg: Bool) -> String {
        
        if isKg {
            let count = truePrice
            return String(format: "%.1f", count)
        } else {
            let count = truePrice / 0.6
            return String(format: "%.1f", count)
        }
    }

    
}
