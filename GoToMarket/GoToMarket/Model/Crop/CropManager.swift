//
//  CropManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct CropManager {
    
    private let provider = CropProvider()
    
    func accessCropQuote(
        task: CropRequestProvider,
        success: @escaping([CropQuote]?) -> Void,
        failure: @escaping(Error) -> Void) {
        provider.getCropQuote(
            request: task,
            success: { cropQuotes in
                let quotesArray = self.provider.cropValidate(fromCropArray: cropQuotes, ofTask: task)
                switch task {
                case .getHistoryQutoes:
                    success(quotesArray)
                case .getInitailQuotes:
                    self.provider.resetAllData(with: quotesArray,
                                               success: { success(nil) },
                                               failure: { error in failure(error) })
                case .getNewQuote:
                    self.provider.updateDatabase(with: quotesArray,
                                                 success: { success(nil) },
                                                 failure: { error in
                                                    failure(error) })
                }
        }, failure: { error in
            failure(error)
        })
    }
    
    
    
}
