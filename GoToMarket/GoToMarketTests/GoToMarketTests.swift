//
//  GoToMarketTests.swift
//  GoToMarketTests
//
//  Created by 許庭瑋 on 2018/6/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import XCTest
@testable import GoToMarket
import Alamofire

class stubsNilRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return nil
    }
}

class stubsValidRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return CropQueryType.updateQuote(lastUpdateDate: nil).getNSURLQueryItem()
    }
}

class stubsInvalidRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return [URLQueryItem(name: "InValid", value: "InValid")]
    }
}

class stubsValidHttpRequest: HTTPRequest {
    
    
    var domainURL: String = "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx"
    var requestType: OpenDataQueryItemConvertable
    
    init(testQueryItem: OpenDataQueryItemConvertable) {
        
        self.requestType = testQueryItem
    }
}



class GoToMarketTests: XCTestCase {
    
    var CropUnderTest: CropProvider!
    var HttpClientUnderTest: HttpClient!
    
    
    override func setUp() {
        super.setUp()
        
        CropUnderTest = CropProvider()
        HttpClientUnderTest = HttpClient.shared
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        CropUnderTest = nil
        HttpClientUnderTest = nil
        super.tearDown()
    }
    
    func test_CropDataWhenInputEmptyString_ExpectNil() {
        //1. given
        let guess = ""
        
        //2. when
        let result = CropUnderTest.getCropData(fromItemCode: guess, itemType: guess)
        
        //3. then
        XCTAssertEqual(result, nil, "getCropData guess is wrong")
    }
    
    
    func test_HttpClientWhenInputValidURL_ExpectSUCCESS() {
        //1. given
        let guess = stubsValidHttpRequest(testQueryItem: stubsValidRequestType())
        let promise = expectation(description: "data.count greater than 0")
        
        //2. when
        let _ = HttpClientUnderTest.request(guess, success: { data in
            
            if data.count > 0 {
                
                promise.fulfill()
            } else {
                
                XCTFail("data.count <= 0")
            }
            
        }) { (error) in
            
            XCTFail("Error: \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    
    func test_HttpClientWhenInputInValidQueryItem_ExpectSUCCESS() {
        //1. given
        let guess = stubsValidHttpRequest(testQueryItem: stubsInvalidRequestType())
        let promise = expectation(description: "data.count equal to 0")
        
        //2. when
        let _ = HttpClientUnderTest.request(guess, success: { data in
            
            if data.count > 0 {
                
                XCTFail("data.count > 0, data = \(data)")
            } else {
                
                promise.fulfill()
                
            }
            
        }) { (error) in
            
            XCTFail("Error: \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    
    
    
    
    
    
}
