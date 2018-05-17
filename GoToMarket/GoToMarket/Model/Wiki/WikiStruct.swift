//
//  WikiStruct.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/16.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct WikiRequest: HTTPRequest {
    
    
    var requestType: OpenDataQueryItemConvertable

    var domainURL: String
    
    init(requestType type: WikiQueryType) {
        self.requestType = type
        self.domainURL = type.getDomainUrl()
    }
}

enum WikiQueryType: OpenDataQueryItemConvertable {
    
    case getImage(itemName: String)
    case getText(itemName: String)
    
    func getDomainUrl() -> String {
        
        switch self {
            
        case .getImage(itemName: let name):
            return WikiApiConstant.wikiImageBaseUrl + name
            
        case .getText(itemName: let name):
            return WikiApiConstant.wikiTextBaseUrl + name
            
        }
    }
    
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return nil
    }
    
    func getItemName() -> String {
        
        switch self {
            
        case .getImage(itemName: let name):
            return name
            
        case .getText(itemName: let name):
            return name
        }
    }
    
}
