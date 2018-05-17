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

    func getCropDataBase(
        task: CropQueryType,
        market: CropMarkets,
        success: @escaping(Bool) -> Void,
        failure: @escaping(Error) -> Void) {
        
        let dataRequest = CropRequest(cropRequestType: task, cropMarket: market, historyCropCode: nil)
        
        provider.getCropQuote(
            request: dataRequest,
            success: { cropQuotes in
                
                let quotesArray = self.provider.marketValidate(fromCropArray: cropQuotes, ofMarketString: dataRequest.market.getCustomString())
                
                switch task {

                case CropQueryType.getInitailQuotes:
                    self.provider.resetAllData(with: quotesArray,
                                               success: { success(true) },
                                               failure: { error in failure(error) })
                case CropQueryType.updateQuote:
                    self.provider.updateDatabase(with: quotesArray,
                                                 success: { success(true) },
                                                 failure: { error in
                                                    failure(error) })
                default:
                    success(false)
                }
        }, failure: { error in
            failure(error)
        })
    }
    
    func getHistoryCropArray(
        market: CropMarkets,
        CropCode: String,
        success: @escaping([CropQuote]) -> Void,
        failure: @escaping(Error) -> Void) {
        
        let historyRequest = CropRequest(cropRequestType: .getHistoryQutoes, cropMarket: market, historyCropCode: CropCode)
        
        provider.getCropQuote(
            request: historyRequest,
            success: { quoteArray in
                
                success(quoteArray)
                
        }, failure: { error in
            
            failure(error)
        })
    }
    
    
}
