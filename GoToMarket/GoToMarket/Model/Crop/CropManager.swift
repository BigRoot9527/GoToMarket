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
    let cropRequest: CropRequest
    
    func accessCropQuote(
        success: @escaping([CropQuote]?) -> Void,
        failure: @escaping(Error) -> Void) {
        let task = CropRequest(cropRequestType: queryType, cropMarket: market)
        provider.getCropQuote(
            request: task,
            success: { cropQuotes in
                let quotesArray = self.provider.marketValidate(fromCropArray: cropQuotes, ofMarket: self.market)
                switch self.queryType {
                case .getHistoryQutoes(CropCode: _):
                    success(quotesArray)
                case .getInitailQuotes:
                    self.provider.resetAllData(with: quotesArray,
                                               success: { success(nil) },
                                               failure: { error in failure(error) })
                case .updateQuote:
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
