//
//  UserManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct LoadingManager {
    
//    var appInitialLoadingTask: [TaskType]?
//    var userCustomLoadingTask: [TaskType]?
    
    let indexKeeper = LoadingIndexKeeper.shared
    
    
    func loadInitialTask() {
        guard let initTasks = indexKeeper.getTaskArray(forState: .appInitialLoadingTask) else { return }
        initTasks.forEach { task in
            switch task {
            case .crop(let cropMarket, let cropState):
                
                
            }
        }
        
    }
    
    
    
    
}
