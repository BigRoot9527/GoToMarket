//
//  CropNewQuotesProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum CropAPIProvider: OpenDataRequest {
    case getNewQuote(Market: CropMarkets)
    case getInitailQuotes(Market: CropMarkets)
    case getHistoryQutoes(Market: CropMarkets, CropCode: String)

    func domainURLString() -> String {
        return CropApiConstant.url
    }
    func urlParameter() -> String {
        switch self {
        case .getHistoryQutoes(Market: let market, CropCode: let cropCode):
            <#code#>
        case .getInitailQuotes(Market: let market):
            <#code#>
        case .getNewQuote(Market: let market):
            
        }
    }
}
struct CropProvider {
    let task: CropAPIProvider
    
}
