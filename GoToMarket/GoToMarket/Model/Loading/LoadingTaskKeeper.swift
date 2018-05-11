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
    
    func saveMarket(_ marketString: String, ofKey key: TaskKeys) {
        
        let keyString = key.getMarketKeyString()
        UserDefaults.standard.set(marketString, forKey: keyString)
    }
    
    func getMarket(ofKey key: TaskKeys) -> String? {
        
        let keyString = key.getMarketKeyString()
        guard let market  = UserDefaults.standard.object(forKey: keyString) as? String else { return nil }
        return market
    }
    
    func saveQueryType(_ typeString: String, ofKey key: TaskKeys) {
        let keyString = key.getQueryTypeKeyString()
        UserDefaults.standard.set(typeString, forKey: keyString)
    }
    
    func getQueryType(ofKey key: TaskKeys) -> String? {
        
        let keyString = key.getQueryTypeKeyString()
        guard let type  = UserDefaults.standard.object(forKey: keyString) as? String else { return nil }
        return type
    }
    
}
