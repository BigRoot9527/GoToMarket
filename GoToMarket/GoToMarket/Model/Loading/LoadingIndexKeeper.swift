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
    private let indexSetKey = "GoToMarket-Index-Key"

    func saveTaskArray(_ indexArray: [TaskType]) {
        UserDefaults.standard.set(indexArray, forKey: indexSetKey)
    }
    
    func getTaskArray() -> [TaskType]? {
        let data = UserDefaults.standard.value(forKey: indexSetKey)
        guard let array = data as? [TaskType] else { return nil }
        return array
    }
    
}
