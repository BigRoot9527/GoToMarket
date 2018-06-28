//
//  HttpClientTests.swift
//  GoToMarketTests
//
//  Created by 許庭瑋 on 2018/6/28.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import XCTest
@testable import GoToMarket
import Alamofire

class MockDataClient: DataRequestGettable {

    var queue: DispatchQueue = DispatchQueue(label: "test.GotoMarket")

    var isCalled: Bool = false

    var passedRequest: URLRequestConvertible?

    func dataRequest(_ request: URLRequestConvertible, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) -> DataRequest? {

        self.isCalled = true

        self.passedRequest = request

        return nil
    }
}

struct FakeRequestType: OpenDataQueryItemConvertable {

    func getNSURLQueryItem() -> [URLQueryItem]? {
        return nil
    }
}

struct StubHTTPRequest: HTTPRequest {

    var domainURL: String = ""
    var requestType: OpenDataQueryItemConvertable = FakeRequestType()
}

class HttpClientTests: XCTestCase {

    var httpClientUnderTest: HttpClient!
    var mockDataClient: MockDataClient!
    var stubHttpRequest: HTTPRequest!

    override func setUp() {
        super.setUp()

        httpClientUnderTest = HttpClient.shared
        mockDataClient = MockDataClient()
        stubHttpRequest = StubHTTPRequest()

    }

    override func tearDown() {
        super.tearDown()

        httpClientUnderTest = nil
        mockDataClient = nil
        stubHttpRequest = nil
    }

    func test_HttpClient_passRequest_expectCorrect() {

        httpClientUnderTest.dataClient = mockDataClient

        httpClientUnderTest.request(stubHttpRequest, success: {_ in}, failure: {_ in})

        guard let outputRequest = mockDataClient.passedRequest as? HTTPRequest else { return }

        XCTAssertEqual(stubHttpRequest.domainURL, outputRequest.domainURL)

        XCTAssertTrue(mockDataClient.isCalled)
    }
}
