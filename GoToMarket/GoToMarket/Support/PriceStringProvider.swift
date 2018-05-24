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
        fromTruePrice truePrice: Double,
        andMultipler mutipler: Double
        ) -> String {
        
        if showInKg {
            let count = truePrice * mutipler
            return String(format: "%.1f", count)
        } else {
            let count = truePrice * mutipler / 0.6
            return String(format: "%.1f", count)
        }
    }
    
    func getTruePriceString(
        fromTruePrice truePrice: Double
        ) -> String {
        
        if showInKg {
            let count = truePrice
            return String(format: "%.1f", count)
        } else {
            let count = truePrice / 0.6
            return String(format: "%.1f", count)
        }
    }
    
    func getWeightTypeButtonString() -> String {
        
        let string = showInKg ? 
            GoToMarketConstant.kgWeightTypeButtonString :
            GoToMarketConstant.tgWeightTypeButtonString
        
        return string
    }
    

    
}
