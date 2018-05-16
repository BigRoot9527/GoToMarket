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
        
        provider.getCropQuote(
            request: cropRequest,
            success: { cropQuotes in
                
                let quotesArray = self.provider.marketValidate(fromCropArray: cropQuotes, ofMarketString: self.cropRequest.market.getCustomString())
            
                
                guard let task = self.cropRequest.requestType as? CropQueryType else { return }
                
                switch task {
                
                case CropQueryType.getHistoryQutoes:
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
