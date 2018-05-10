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
    let cropQuest: CropRequest
    
    func accessCropQuote(
        success: @escaping([CropQuote]?) -> Void,
        failure: @escaping(Error) -> Void) {
        
        provider.getCropQuote(
            request: cropQuest,
            success: { cropQuotes in
                
                let quotesArray = self.provider.marketValidate(fromCropArray: cropQuotes, ofMarketString: self.cropQuest.market.getCustomString())
                
                let aaa = self.cropQuest.requestType.returnSwichableSelf()
                
                switch aaa {
                
                case CropQueryType.getHistoryQutoes(CropCode: _):
                    success(quotesArray)
                
                case CropQueryType.getInitailQuotes:
                    self.provider.resetAllData(with: quotesArray,
                                               success: { success(nil) },
                                               failure: { error in failure(error) })
                case CropQueryType.updateQuote:
                    self.provider.updateDatabase(with: quotesArray,
                                                 success: { success(nil) },
                                                 failure: { error in
                                                    failure(error) })
                default:
                    break
                }
        }, failure: { error in
            failure(error)
        })
    }
    
    
    
}
