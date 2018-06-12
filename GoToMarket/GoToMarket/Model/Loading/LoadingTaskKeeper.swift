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

    func saveUpdateDate(ofKey key: TaskKeys) {

        let updateToday = Date()
        let keyString = key.getUpdateDateKeyString()
        UserDefaults.standard.set(updateToday, forKey: keyString)
    }

    func getUpdateDate(ofKey key: TaskKeys) -> Date? {

        let keyString = key.getUpdateDateKeyString()
        guard let date  = UserDefaults.standard.object(forKey: keyString) as? Date else { return nil }
        return date
    }

    func resetData(ofKey key: TaskKeys) {
        UserDefaults.standard.removeObject(forKey: key.getMarketKeyString())
        UserDefaults.standard.removeObject(forKey: key.getUpdateDateKeyString())
    }

}
