//
//  UserManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct LoadingManager {

    let indexKeeper = LoadingIndexKeeper.shared

    func loadTask(forState state: LoadingTime) {
        guard let initTasks = indexKeeper.getTaskArray(forState: state) else { return }
        let dispatchGroup = DispatchGroup()
        initTasks.forEach { task in
            dispatchGroup.enter()
            switch task {
            case .crop(let cropTask):
                let manager = CropManager()
                manager.accessCropQuote(
                    task: cropTask,
                    success: { _ in
                        print("Crop Data \(cropTask) Loaded")
                        dispatchGroup.leave()
                },
                    failure: { _ in
                        print("Crop Data \(cropTask) Loaded")
                        dispatchGroup.leave()
                })
            }
        }
    }
    
    func createAndSaveTask(for)
    
    

    
    
    
    
    
}
