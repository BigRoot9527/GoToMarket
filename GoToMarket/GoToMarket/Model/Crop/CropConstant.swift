//
//  GoToMarketConstant.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
struct CropApiConstant {
    static let url = "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx?"
    static let maxDataAmount = "$top"
    static let skipDataAmout = "$skip"
    static let searchCropCode = "CropCode"
    static let searchCropName = "Crop"
    static let fixedSearchMarket = "Market"
    static let searchFromDate = "StartDate"
    static let searchEndDate = "EndDate"
}
enum CropMarkets: String {
    case taipei = "台北一"
    case tauyuan = "桃農"
    case taichung = "台中"
    case nantou = "南投"
    case kaoshung = "高雄"
    case taidong = "台東"
    case ilan = "宜蘭"
    func getCode() -> Int {
        switch self {
        case .taipei:
            return 109
        case .tauyuan:
            return 338
        case .taichung:
            return 400
        case .nantou:
            return 540
        case .kaoshung:
            return 800
        case .taidong:
            return 930
        case .ilan:
            return 260
        }
    }
}
