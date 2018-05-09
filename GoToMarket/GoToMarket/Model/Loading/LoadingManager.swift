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
    
    func doingSavingTask() {
        guard let initTasks = indexKeeper.getTaskArray() else { return }
        loadAndSave(fromTasks: initTasks)
    }
    
    func createCustomTask(type: TaskType, request:) -> TaskType {
        let initTask: TaskType = .crop(.getInitailQuotes(Market: .taidong))
    }
    
    private func loadAndSave(fromTasks passedTasks: [TaskType]) {
        var newTaskArrayAfterLoading: [TaskType] = []
        let dispatchGroup = DispatchGroup()
        passedTasks.forEach { initTask in
            dispatchGroup.enter()
            var checkIfSucceeded: Bool = true
            var newTaskAfterLoading: TaskType
            switch initTask {
            case .crop(let cropTask):
                let manager = CropManager()
                manager.accessCropQuote(
                    task: cropTask,
                    success: { _ in
                        print("Crop Data \(cropTask) Loaded")
                        //add loading process counter
                        checkIfSucceeded = true
                        dispatchGroup.leave()
                },
                    failure: { _ in
                        print("Crop Data \(cropTask) Loaded")
                        checkIfSucceeded = false
                        dispatchGroup.leave()
                })
                if checkIfSucceeded {
                    newTaskAfterLoading = setToUpdateTaskAfterInit(of: initTask)
                } else {
                    newTaskAfterLoading = initTask
                }
                newTaskArrayAfterLoading.append(newTaskAfterLoading)
            }
        }
        LoadingIndexKeeper.shared.saveTaskArray(newTaskArrayAfterLoading)
    }

    private func setToUpdateTaskAfterInit(of task: TaskType) -> TaskType {
        switch task {
        case .crop( let request ):
            let market = request.getMarket()
            let newRequest: CropRequestProvider = .getNewQuote(Market: market)
            let newTaskType: TaskType = .crop(newRequest)
            return newTaskType
        }
    }

    
}
