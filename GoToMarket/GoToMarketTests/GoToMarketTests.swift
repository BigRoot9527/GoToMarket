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

class StubsNilRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return nil
    }
}

class StubsValidRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return CropQueryType.updateQuote(lastUpdateDate: nil).getNSURLQueryItem()
    }
}

class StubsInvalidRequestType: OpenDataQueryItemConvertable {
    func getNSURLQueryItem() -> [URLQueryItem]? {
        return [URLQueryItem(name: "InValid", value: "InValid")]
    }
}

class StubsValidHttpRequest: HTTPRequest {

    var domainURL: String = "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx"
    var requestType: OpenDataQueryItemConvertable

    init(testQueryItem: OpenDataQueryItemConvertable) {

        self.requestType = testQueryItem
    }
}

class GoToMarketTests: XCTestCase {

    var cropUnderTest: CropProvider!
    var httpClientUnderTest: HttpClient!

    override func setUp() {
        super.setUp()

        cropUnderTest = CropProvider()
        httpClientUnderTest = HttpClient.shared

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        cropUnderTest = nil
        httpClientUnderTest = nil
        super.tearDown()
    }

    func test_CropDataWhenInputEmptyString_ExpectNil() {
        //1. given
        let guess = ""

        //2. when
        let result = cropUnderTest.getCropData(fromItemCode: guess, itemType: guess)

        //3. then
        XCTAssertEqual(result, nil, "getCropData guess is wrong")
    }

    func test_HttpClientWhenInputValidURL_ExpectSUCCESS() {
        //1. given
        let guess = StubsValidHttpRequest(testQueryItem: StubsValidRequestType())
        let promise = expectation(description: "data.count greater than 0")

        //2. when
        _ = httpClientUnderTest.request(guess, success: { data in

            if data.count > 0 {

                promise.fulfill()
            } else {

                XCTFail("data.count <= 0")
            }

        }, failure: { (error) in

            XCTFail("Error: \(error.localizedDescription)")
        })

        waitForExpectations(timeout: 15, handler: nil)
    }

    func test_HttpClientWhenInputInValidQueryItem_ExpectSUCCESS() {
        //1. given
        let guess = StubsValidHttpRequest(testQueryItem: StubsInvalidRequestType())
        let promise = expectation(description: "data.count equal to 0")

        //2. when
        _ = httpClientUnderTest.request(guess, success: { data in

            if data.count > 0 {

                XCTFail("data.count > 0, data = \(data)")
            } else {

                promise.fulfill()

            }

        }, failure: { (error) in

            XCTFail("Error: \(error.localizedDescription)")
        })

        waitForExpectations(timeout: 15, handler: nil)
    }

}
