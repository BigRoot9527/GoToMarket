//
//  ODHTTPRequest.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation



protocol OpenDataRequest: HTTPRequest {

    var market: MarketEnum { get set }
    var additionalURLQueryItem: URLQueryItem? { get set }
    
}

extension OpenDataRequest {
    
    func urlQueryItems() -> [URLQueryItem] {
        var returnArray = requestType.getNSURLQueryItem() + market.getNSURLQueryItem()
        if let addtionalItem = additionalURLQueryItem {
            returnArray.append(addtionalItem)
        }
        return returnArray
    }

    

}


