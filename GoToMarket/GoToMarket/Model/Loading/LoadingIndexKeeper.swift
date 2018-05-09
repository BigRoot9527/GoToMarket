//
//  LoadingIndexKeeper.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/9.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

class LoadingIndexKeeper {
    
    static let shared = LoadingIndexKeeper()
    private init() {}

    func saveTaskArray(_ indexArray: [TaskType], forState state: LoadingTime) {
        UserDefaults.standard.set(indexArray, forKey: state.getKey())
    }
    
    func getTaskArray(forState state: LoadingTime) -> [TaskType]? {
        let data = UserDefaults.standard.value(forKey: state.getKey())
        guard let array = data as? [TaskType] else { return nil }
        return array
    }
    
}
