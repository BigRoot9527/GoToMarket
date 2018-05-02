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
    case taichung = "台中市"
    case nantou = "南投市"
    case kaoshung = "高雄市"
    case taidong = "台東市"
    case ilan = "宜蘭市"
}
