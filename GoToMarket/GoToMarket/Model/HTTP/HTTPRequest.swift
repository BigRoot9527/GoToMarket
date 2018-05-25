//
//  HTTPRequest.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/16.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

protocol HTTPRequest {
    var domainURL: String { get set }
    var requestType: OpenDataQueryItemConvertable { get set }
    //Optional
    func domainURLString() -> String
    func urlQueryItems() -> [URLQueryItem]?
    func request() throws -> URLRequest
}

extension HTTPRequest {
    
    func request() throws -> URLRequest {
        
        guard var components = URLComponents(string: domainURLString()) else {
            throw GoToMarketError.OpenDataServerError
        }
        
        if let items = urlQueryItems() {
            components.queryItems = items
        }
        
        guard let openDataUrl = components.url else {
            throw GoToMarketError.OpenDataServerError
        }
        var request = URLRequest(url: openDataUrl)
        request.httpMethod = "GET"
        return request
    }
    
    func domainURLString() -> String {
        return domainURL
    }
    
    func urlQueryItems() -> [URLQueryItem]? {
        return requestType.getNSURLQueryItem()
    } 
}
