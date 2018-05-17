//
//  WikiProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/16.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation


struct WikiManager {
    
    private weak var httpClient = HttpClient.shared
    
    func getWikiImageUrl(
        fromItemName name: String,
        success: @escaping (URL?) -> Void,
        failure: @escaping (Error) -> Void ) {
        
        let wikiRequest = WikiRequest(requestType: .getImage(itemName: name.trimed().urlEncoded()))
        
        print("request.urlString() = \(try? wikiRequest.request())")
        
        httpClient?.request(
            wikiRequest,
            success: { data in
                
                guard
                    let responseString = String(data: data, encoding: String.Encoding.utf8),
                    let urlString = responseString.matchesString(fromRegex: WikiApiConstant.regexForImageUrl)?.first,
                    let url: URL = URL(string: urlString)
                    else {
            
                        success(nil)
                        return
                }
                
                success(url)
            },
            failure: { error in
                print("Error from WikiProvider: \(error)")
                failure(error)
        })
    }
    
    func getWikiText(
        fromItemName name: String,
        success: @escaping(String?) -> Void,
        failure: @escaping(Error) -> Void) {
        
        let wikiRequest = WikiRequest(requestType: .getText(itemName: name.trimed().urlEncoded()))
        
        print("request.urlString() = \(try? wikiRequest.request())")
        
        httpClient?.request(
            wikiRequest,
            success: { data in
                                
            guard
                let responseString = String(data: data, encoding: String.Encoding.utf8) as String? ,
                responseString != WikiApiConstant.noResponseString
                else {
                    DispatchQueue.main.async {
                        success(nil)
                    }
                    return
            }
                DispatchQueue.main.async {
                    success(responseString)
                    //TODO: replace the utf8 /r/n to NString /n
                }
        },
            failure: { error in
                print("Error from WikiProvider: \(error)")
                DispatchQueue.main.async {
                    failure(error)
                }
        })
    }
    
}
