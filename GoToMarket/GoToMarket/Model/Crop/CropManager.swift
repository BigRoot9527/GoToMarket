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
    let queryType: CropQueryType
    let market: CropMarkets
    var marketString: String {
        return market.getCustomString()
    }
    let cropApiRequest: CropRequest
    
    func accessCropQuote(
        success: @escaping([CropQuote]?) -> Void,
        failure: @escaping(Error) -> Void) {
//        let task = CropRequest(cropRequestType: queryType, cropMarket: market)
        provider.getCropQuote(
            request: cropApiRequest,
            success: { cropQuotes in
                let quotesArray = self.provider.marketValidate(fromCropArray: cropQuotes, ofMarketString: self.cropApiRequest.market.getCustomString())
                let task = self.cropApiRequest.requestType.getEnumCase()
                switch task {
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
