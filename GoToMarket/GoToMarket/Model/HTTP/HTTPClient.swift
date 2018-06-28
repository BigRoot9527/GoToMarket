//
//  ODHTTPResponse.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import Alamofire

protocol DataRequestGettable {

    var queue: DispatchQueue { get set }

    func dataRequest(
        _ request: URLRequestConvertible,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest?
}

class HttpClient {

    static let shared = HttpClient()
    private let queue: DispatchQueue
    private var dataClient: DataRequestGettable

    private init (customClient: DataRequestGettable? = nil) {

        if let client = customClient {
            dataClient = client
            queue = client.queue

        } else {

            queue = DispatchQueue(
                label: String(describing: HttpClient.self) + UUID().uuidString,
                qos: .default,
                attributes: .concurrent)
            dataClient = OpenDataClient(queue: queue)
        }
    }

    @discardableResult
    func request(
        _ openHTTPRequest: HTTPRequest,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {
        do {
            return try dataClient.dataRequest(openHTTPRequest.request(), success: success, failure: failure)

        } catch {
            print("Error from ODHTTPClient: \(error)")
            failure(error)
            return nil
        }
    }
}

private struct OpenDataClient: DataRequestGettable {

    var queue: DispatchQueue

    @discardableResult
    func dataRequest(
        _ request: URLRequestConvertible,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {
        return Alamofire.SessionManager.default.request(request).validate().responseData(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error)

                }
        })
    }
}
