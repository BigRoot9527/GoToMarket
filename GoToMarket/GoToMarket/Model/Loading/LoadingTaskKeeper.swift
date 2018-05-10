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
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: market)
        UserDefaults.standard.set(encodedData, forKey: keyString)
    }
    
    func getMarket(ofKey key: TaskKeys) -> MarketEnum? {
        let keyString = key.getMarketKeyString()
        
        guard let decoded  = UserDefaults.standard.object(forKey: keyString) as? Data, let decodedMarket = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? MarketEnum else { return nil }
        return decodedMarket
    }
    
    func saveQueryType(_ type: QueryTypeEnum, ofKey key: TaskKeys) {
        let keyString = key.getQueryTypeKeyString()
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: type)
        UserDefaults.standard.set(encodedData, forKey: keyString)
    }
    
    func getQueryType(ofKey key: TaskKeys) -> QueryTypeEnum? {
        let keyString = key.getQueryTypeKeyString()
        guard let decoded  = UserDefaults.standard.object(forKey: keyString) as? Data, let decodedQueryType = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? QueryTypeEnum else { return nil }
        return decodedQueryType
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
