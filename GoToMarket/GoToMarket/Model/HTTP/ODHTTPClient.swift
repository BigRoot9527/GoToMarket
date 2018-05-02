//
//  ODHTTPResponse.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import Alamofire

class OpenDataClient {
    static let shared = OpenDataClient()
    private let queue: DispatchQueue
    private init () {
        queue = DispatchQueue(label: String(describing: OpenDataClient.self) + UUID().uuidString, qos: .default, attributes: .concurrent)
    }
    @discardableResult
    private func request(
        _ request: URLRequestConvertible,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest {
        return Alamofire.SessionManager.default.request(request).validate().responseData(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            }
        )
    }
    @discardableResult
    func request(
        _ OpenHTTPRequest: OpenDataRequest,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {
        do {
            return try request(OpenHTTPRequest.request(), success: success, failure: failure)
        } catch {
            print("Error from ODHTTPClient: \(error)")
            failure(error)
            return nil
        }
    }
        
}
