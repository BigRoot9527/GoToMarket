//
//  PriceStringProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

class PriceStringProvider {
    
    static let shared = PriceStringProvider()
    private init() {}
    
    var showInKg: Bool = true
    
    func getSellPriceString(
        fromSellingPrice sellingPrice: Double
        ) -> String {
        
        if showInKg {
            return String(format: "%.1f", sellingPrice)
        } else {
            return String(format: "%.1f", sellingPrice * 0.6)
        }
    }
    
    func getTruePriceString(
        fromTruePrice truePrice: Double
        ) -> String {
        
        if showInKg {
            let count = truePrice
            return String(format: "%.1f", count)
        } else {
            let count = truePrice * 0.6
            return String(format: "%.1f", count)
        }
    }
    
    func getWeightTypeButtonString() -> String {
        
        let string = showInKg ? 
            GoToMarketConstant.kgWeightTypeButtonString :
            GoToMarketConstant.tgWeightTypeButtonString
        
        return string
    }
    
    func getSegmentedControlIndex() -> Int {
        
        return showInKg ? 0 : 1
    }
}
