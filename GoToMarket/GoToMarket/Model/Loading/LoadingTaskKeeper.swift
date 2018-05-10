//
//  LoadingIndexKeeper.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/9.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation




class LoadingTaskKeeper {
    
    static let shared = LoadingTaskKeeper()
    private init() {}
    
    func saveMarket(_ market: MarketEnum, ofKey key: TaskKeys) {
        let keyString = key.getMarketKeyString()
        UserDefaults.standard.set(market, forKey: keyString)
    }
    
    func getMarket(ofKey key: TaskKeys) -> MarketEnum? {
        let keyString = key.getMarketKeyString()
        switch key {
        case .crop:
            guard let market = UserDefaults.standard.value(forKey: keyString) as? CropMarkets else { return nil }
            return market
        default:
            return nil
        }
    }
    
    func saveQueryType(_ type: QueryTypeEnum, ofKey key: TaskKeys) {
        let keyString = key.getQueryTypeKeyString()
        UserDefaults.standard.set(type, forKey: keyString)
    }
    
    func getMarket(ofKey key: TaskKeys) -> QueryTypeEnum? {
        let keyString = key.getMarketKeyString()
        switch key {
        case .crop:
            guard let type = UserDefaults.standard.value(forKey: keyString) as? CropQueryType else { return nil }
            return type
        default:
            return nil
        }
    }
    

//    func getTask(fromKey key: TaskKeys) -> Task? {
//        switch key {
//        case .crop:
//            guard let task = UserDefaults.standard.value(forKey:key.getKeyString()) as? CropTask
//                else { return nil }
//            return task
//        default:
//            return nil
//        }
//    }
    
}
