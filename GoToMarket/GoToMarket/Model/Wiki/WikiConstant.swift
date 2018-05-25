//
//  WikiConstant.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/16.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

struct WikiApiConstant {

    //TODO: get data from real Wiki REST api
    //https://zh.wikipedia.org/api/rest_v1/page/summary/香蕉
    static let wikiImageBaseUrl = "http://signalr.tn.edu.tw/OWikipedia/api/pageimage/"

    static let wikiTextBaseUrl = "http://signalr.tn.edu.tw/OWikipedia/api/abstract/"
    
    static let regexForImageUrl = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
    
    static let noResponseString = "null"
    
}
