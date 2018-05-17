//
//  QuotesStructs.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct CropQuote: Decodable {
    let date: String
    let cropCode: String
    let cropName: String
    let marketName: String
    let averagePrice: Double
    
    private enum CodingKeys: String, CodingKey {
        case date = "交易日期"
        case cropCode = "作物代號"
        case cropName = "作物名稱"
        case marketName = "市場名稱"
        case averagePrice = "平均價"
    }
}

struct CropRequest: OpenDataRequest {
    
    
    var additionalURLQueryItem: URLQueryItem?
    var domainURL: String = CropApiConstant.baseURL
    var market: MarketEnum
    var requestType: OpenDataQueryItemConvertable
    
    init (cropRequestType: CropQueryType, cropMarket: CropMarkets, historyCropCode: String?) {
        self.requestType = cropRequestType
        self.market = cropMarket
        if let code = historyCropCode {
            self.additionalURLQueryItem = URLQueryItem(name: CropApiConstant.searchCropCode, value: code)
        }
    }
    
}

enum CropMarkets:String, MarketEnum {

    case taipei
    case tauyuan
    case taichung
    case nantou
    case kaoshung
    case taidong
    case ilan

    func getCustomString() -> String {
        switch self {
        case .taipei:
            return CropApiConstant.taipei
        case .ilan:
            return CropApiConstant.ilan
        case .kaoshung:
            return CropApiConstant.kaoshung
        case .nantou:
            return CropApiConstant.nantou
        case .taichung:
            return CropApiConstant.taichung
        case .taidong:
            return CropApiConstant.taidong
        case .tauyuan:
            return CropApiConstant.tauyuan
        }
    }

    func getNSURLQueryItem() -> [URLQueryItem]? {
        let marketTitle = CropApiConstant.fixedSearchMarket
        switch self {
        case .taipei:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.taipei)]
        case .ilan:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.ilan)]
        case .kaoshung:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.kaoshung)]
        case .nantou:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.nantou)]
        case .taichung:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.taichung)]
        case .taidong:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.taidong)]
        case .tauyuan:
            return [URLQueryItem(name: marketTitle, value: CropApiConstant.tauyuan)]
        }
    }
}

enum HistoryPeriod: Int {
    case fromLastMonth = 1
    case fromLastSeason = 3
}


enum CropQueryType: OpenDataQueryItemConvertable {
    
    case updateQuote(lastUpdateDate: Date?)
    case getHistoryQutoes(HistoryPeriod)
    
    func getNSURLQueryItem() -> [URLQueryItem]? {
        let fromDateTitle = CropApiConstant.searchFromDate
        let endDateTitle = CropApiConstant.searchEndDate
        switch self {
        
        case .updateQuote(let date):
            
            let fromDateItem =
                URLQueryItem(
                    name: fromDateTitle,
                    value: TwDateProvider.getUpdateStartDateString(fromLastDate: date))
            
            let toDateItem =
                URLQueryItem(
                    name: endDateTitle,
                    value: TwDateProvider.getTodayString())
            
            return [fromDateItem,toDateItem]
            
            
        case .getHistoryQutoes(let period):
            
            let fromDateItem =
                URLQueryItem(
                    name: fromDateTitle,
                    value: TwDateProvider.getMonthsAgoString(fromMonthsAgo: period.rawValue))
            
            let toDateItem =
                URLQueryItem(
                    name: endDateTitle,
                    value: TwDateProvider.getTodayString())
            
            return [fromDateItem,toDateItem]
            
        }
    }
}


