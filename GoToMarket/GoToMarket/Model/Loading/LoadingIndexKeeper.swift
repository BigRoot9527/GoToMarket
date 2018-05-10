//
//  LoadingIndexKeeper.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/9.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum taskKeys {
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
}



class LoadingIndexKeeper {
    
    static let shared = LoadingIndexKeeper()
    private init() {}
    
    
    func saveTaskArray(_ indexArray: [TaskType]) {
        UserDefaults.standard.set(indexArray, forKey: indexSetKey)
    }

    
    func getTask(fromKey key: taskKeys) -> OpenDataRequest {
        let data = UserDefaults.standard.value(forKey: indexSetKey)
        guard let array = data as? [TaskType] else { return nil }
        return array
    }
    
}
