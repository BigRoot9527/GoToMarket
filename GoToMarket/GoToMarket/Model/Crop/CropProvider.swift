//
//  CropNewQuotesProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum CropRequestProvider: OpenDataRequest {
    
    case getNewQuote(Market: CropMarkets)
    case getInitailQuotes(Market: CropMarkets)
    case getHistoryQutoes(Market: CropMarkets, CropCode: String)

    func domainURLString() -> String {
        return CropApiConstant.url
    }
    
    func urlParameter() -> String {
        switch self {
        case .getHistoryQutoes(Market: let market, CropCode: let cropCode):
            let param =
                "\(CropApiConstant.searchCropCode)=\(cropCode)"
                + "&\(CropApiConstant.fixedSearchMarket)=\(market.rawValue)"
                + "&\(CropApiConstant.searchFromDate)=\(TwDateProvider.getLastMonthString())"
                + "&\(CropApiConstant.searchEndDate)=\(TwDateProvider.getTodayString())"
            return param
        case .getInitailQuotes(Market: let market):
            let param =
                "\(CropApiConstant.searchFromDate)=\(TwDateProvider.getLastWeekString())"
                + "&\(CropApiConstant.searchEndDate)=\(TwDateProvider.getTodayString())"
                + "&\(CropApiConstant.fixedSearchMarket)=\(market.rawValue)"
            return param
        case .getNewQuote(Market: let market):
            let param = "\(CropApiConstant.fixedSearchMarket)=\(market.rawValue)"
            return param
        }
    }
    
    func getMarket() -> CropMarkets {
        switch self {
        case .getHistoryQutoes(let market, _):
            return market
        case .getInitailQuotes(let market):
            return market
        case .getNewQuote(let market):
            return market
        }
    }
}
struct CropProvider {
    private weak var httpClient = OpenDataClient.shared
    private let decoder = JSONDecoder()
    
    func getCropQuote(
        request: CropRequestProvider,
        success: @escaping([CropQuote]) -> Void,
        failure: @escaping(Error) -> Void )
    {
        print("request.urlString() = \(request.urlString())")
        httpClient?.request(request,
        success: { data in
            do
            {
                let response = try self.decoder.decode([CropQuote].self, from: data)
                success(response)
            }
            catch
            {
                print("Error when CropProvider parsing Json")
            }
        },
        failure: { error in
            print("Error from CropProvider: \(error)")
            failure(error)
        })
    }
    
}
