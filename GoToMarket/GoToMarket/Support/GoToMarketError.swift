//
//  GoToMarketError.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
// 

import Foundation

enum GoToMarketError: String, Error {
    case openDataServerError = "OpenData client error: cannot get URL"
    case fetchError = "No Fetch Data of Quote Info while dealling with not initail data "
    case marketError = "Need A Specified Market to search for Data"
    case validContext = "Context No available"

    var localizedDescription: String {
        return "love u"
    }
}
