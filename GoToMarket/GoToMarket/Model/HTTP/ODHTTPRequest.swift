//
//  ODHTTPRequest.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation



protocol OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]
}

protocol OpenDataRequest {
    var domainURL: String { get set }
    var requestType: requestEnum { get set }
    var market: marketEnum { get set }
    //Optional
    func domainURLString() -> String
    func urlQueryItems() -> [URLQueryItem]
    func request() throws -> URLRequest
}

extension OpenDataRequest {

    func request() throws -> URLRequest {
        var components = URLComponents(string: domainURLString())
        components?.queryItems = urlQueryItems()
        
        guard let openDataUrl = components?.url else {
            throw GoToMarketError.OpenDataServerError
        }
        var request = URLRequest(url: openDataUrl)
        request.httpMethod = "GET"
        return request
    }
    
    func domainURLString() -> String {
        return domainURL
    }
    
    func urlQueryItems() -> [URLQueryItem] {
        let requestArray = requestType.getNSURLQueryItem()
        let marketArray = market.getNSURLQueryItem()
        return requestArray + marketArray
    }
}


