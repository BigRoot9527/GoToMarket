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

    func saveCropDataBase(
        fromMarket input: CropMarkets?,
        success: @escaping(Bool) -> Void,
        failure: @escaping(Error) -> Void) {
        
        let lastUpdateDate: Date?
        
        var requestMarket: CropMarkets
        
        //Check if is the First Load of Market
        var isFirstTimeUpdate: Bool
        
        //Market: Input != nil > reset
        //Input == nil default != nil > update
        //all nil > error
        if let inputMarket = input {
            
            requestMarket = inputMarket
            isFirstTimeUpdate = true
            lastUpdateDate = nil
            
        } else {
            
            guard let defaultString = LoadingTaskKeeper.shared.getMarket(ofKey: .crop),
                let defaultMarket = CropMarkets(rawValue: defaultString) else {
                    
                    failure(GoToMarketError.MarketError)
                    return
            }
            
            requestMarket = defaultMarket
            isFirstTimeUpdate = false
            lastUpdateDate = LoadingTaskKeeper.shared.getUpdateDate(ofKey: .crop)
            
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
                    ofMarketString: requestMarket.rawValue)
                
                //Set update time to today
                LoadingTaskKeeper.shared.saveUpdateDate(ofKey: .crop)
                //Set the Crop market first time ( if defaul market = nil & market been input )
                LoadingTaskKeeper.shared.saveMarket(requestMarket.rawValue, ofKey: .crop)
                
                if isFirstTimeUpdate {
                    self.provider.resetAllData(
                        with: quotesArray,
                        
                        success: {
                            
                            DispatchQueue.main.async {
                                success(true)
                            } },
                        
                        failure: { error in
                            
                            DispatchQueue.main.async {
                                failure(error)
                            } })
                }
                else
                {
                    self.provider.updateDatabase(
                        with: quotesArray,
                        
                        success: {
                            
                            DispatchQueue.main.async {
                                success(true)
                            }
                    },
                        
                        failure: { error in
                            
                            DispatchQueue.main.async {
                                failure(error)
                            }
                    })
                }
                
        },
            failure: { error in
            
            DispatchQueue.main.async {
                failure(error)
            }
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
            return
        }
        
        let historyRequest = CropRequest(
            cropRequestType: .getHistoryQutoes(period),
            cropMarket: defaultMarket,
            historyCropCode: CropCode)
        
        provider.getCropQuote(
            request: historyRequest,
            
            success: { quoteArray in
                
                DispatchQueue.main.async {
                    //to make array old >>> new
                    success(quoteArray.reversed())
                } },
            
            failure: { error in
                
                DispatchQueue.main.async {
                    failure(error)
                } })
    }
    
    func getCropData(formItemCode code: String) -> CropDatas? {
        
        return provider.getCropData(fromItemCode: code, itemType: GoToMarketConstant.itemTypeCoreDataNameForCrops)
    }
}
