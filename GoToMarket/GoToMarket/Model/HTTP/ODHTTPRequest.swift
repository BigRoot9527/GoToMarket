//
//  ODHTTPRequest.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

protocol OpenDataRequest {
    func domainURLString() -> String
    func urlParameter() -> String
    //Optional
    func urlString() -> String
    func request() throws -> URLRequest
}

extension OpenDataRequest {
    func urlString() -> String { return domainURLString() + urlParameter() }
    func request() throws -> URLRequest {
        let url = URL(string: urlString().urlEncoded())
        guard let openDataUrl = url else {
            throw GoToMarketError.OpenDataServerError
        }
        var request = URLRequest(url: openDataUrl)
        request.httpMethod = "GET"
        return request
    }
}
