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
    
    func saveTask(_ task: Task) {
        let key = task.ApiType.getKeyString()
        UserDefaults.standard.set(task, forKey: key)
    }

    func getTask(fromKey key: TaskKeys) -> Task? {
        switch key {
        case .crop:
            guard let task = UserDefaults.standard.value(forKey:key.getKeyString()) as? CropTask
                else { return nil }
            return task
        default:
            return nil
        }
    }
    
}
