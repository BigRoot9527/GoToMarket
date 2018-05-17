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
        fromMarket marketInput: CropMarkets?,
        success: @escaping(Bool) -> Void,
        failure: @escaping(Error) -> Void) {
        
        let lastUpdateDate: Date? = LoadingTaskKeeper.shared.getUpdateDate(ofKey: .crop)
        
        var requestMarket: CropMarkets
        
        //Check if is the First Load Update of Market
        var isFirstTimeUpdate: Bool
        
        //Market: UserDefault > Input > Error
        if let string = LoadingTaskKeeper.shared.getMarket(ofKey: .crop),
            let defaultMarket = CropMarkets(rawValue: string) {
            requestMarket = defaultMarket
            isFirstTimeUpdate = false
        }
        else {
            guard let inputMarket = marketInput else {
                failure(GoToMarketError.MarketError)
            }
            requestMarket = inputMarket
            isFirstTimeUpdate = true
        }
        
        let dataRequest = CropRequest(
            cropRequestType: .updateQuote(lastUpdateDate: lastUpdateDate),
            cropMarket: requestMarket,
            historyCropCode: nil)

        provider.getCropQuote(
            request: dataRequest,
            success: { cropQuotes in
                
                let quotesArray = self.provider.marketValidate(
                    fromCropArray: cropQuotes,
                    ofMarketString: dataRequest.market.getCustomString())
                
                //Set update time to today
                LoadingTaskKeeper.shared.saveUpdateDate(ofKey: .crop)
                //Set the Crop market first time ( if defaul market = nil & market been input )
                LoadingTaskKeeper.shared.saveMarket(usedMarket.rawValue, ofKey: .crop)
                
                if isFirstTimeUpdate {
                    self.provider.resetAllData(
                        with: quotesArray,
                        success: { success(true) },
                        failure: { error in failure(error) })
                } else {
                    self.provider.updateDatabase(
                        with: quotesArray,
                        success: { success(true) },
                        failure: { error in failure(error) })
                }
                
        }, failure: { error in
            failure(error)
        })
    }
    
    func getHistoryCropArray(
        CropCode: String,
        HistoryPeriod period: HistoryPeriod,
        success: @escaping([CropQuote]) -> Void,
        failure: @escaping(Error) -> Void) {
        
        guard
            let string = LoadingTaskKeeper.shared.getMarket(ofKey: .crop),
            let defaultMarket = CropMarkets(rawValue: string)
        else {
            failure(GoToMarketError.MarketError)
        }
        
        let historyRequest = CropRequest(
            cropRequestType: .getHistoryQutoes(period),
            cropMarket: defaultMarket,
            historyCropCode: CropCode)
        
        provider.getCropQuote(
            request: historyRequest,
            success: { quoteArray in success(quoteArray) },
            failure: { error in failure(error) })
    } 
}
