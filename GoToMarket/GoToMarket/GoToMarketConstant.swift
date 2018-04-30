//
//  GoToMarketConstant.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
struct ApiConstant {
    struct CropApi {
        static let url = "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx"
        static let maxDataAmount = "top"
        static let skipDataAmout = "skip"
        static let searchCropCode = "CropCode"
        static let searchCropName = "Crop"
        static let fixedSearchMarket = "Market = 台北"
        static let searchFromDate = "StartDate"
        static let searchEndDate = "EndDate"
    }
}
