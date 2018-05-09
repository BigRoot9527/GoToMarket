//
//  User.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/9.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation


enum LoadingTime: String {
    case appInitialLoadingTask
    case userCustomLoadingTask
    
    func getKey() -> String {
        return self.rawValue
    }
}

//enum WillLoadStatus {
//    case loadInitialData
//    case loadUpdateData
//}

enum TaskType {
    case crop(CropRequestProvider)
}


