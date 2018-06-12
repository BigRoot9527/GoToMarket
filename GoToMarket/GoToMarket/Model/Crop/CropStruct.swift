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

enum CropMarkets: String, MarketEnum, EnumCollection {

    case taipei = "台北一"
    case tauyuan = "桃農"
    case taichung = "台中市"
    case nantou = "南投市"
    case kaoshung = "高雄市"
    case taidong = "台東市"
    case ilan = "宜蘭市"

    func getItemTypeName() -> String {

        return GoToMarketConstant.itemTypeNameForCrops

    }

    func getNSURLQueryItem() -> [URLQueryItem]? {

        let marketTitle = CropApiConstant.fixedSearchMarket

        return [URLQueryItem(name: marketTitle, value: self.rawValue)]
    }
}

enum HistoryPeriod: Int {
    case fromLastMonth = 1
    case fromLastSeason = 3

    func getLineChartLabelText() -> String {
        switch self {
        case .fromLastMonth:
            return GoToMarketConstant.oneMonthChartLabelName
        case .fromLastSeason:
            return GoToMarketConstant.oneSeasonChartLabelName
        }
    }
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
                    value: TwDateProvider.getUpdateStartDateString(fromLastDate: date)
            )

            let toDateItem =
                URLQueryItem(
                    name: endDateTitle,
                    value: TwDateProvider.getTodayString()
            )

            return [fromDateItem, toDateItem]

        case .getHistoryQutoes(let period):

            let fromDateItem =
                URLQueryItem(
                    name: fromDateTitle,
                    value: TwDateProvider.getMonthsAgoString(fromMonthsAgo: period.rawValue))

            let toDateItem =
                URLQueryItem(
                    name: endDateTitle,
                    value: TwDateProvider.getTodayString())

            return [fromDateItem, toDateItem]

        }
    }
}
