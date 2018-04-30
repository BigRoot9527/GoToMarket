//
//  CropQuoteManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import Alamofire

protocol CropQuoteManagerDelegate: class {
    func manager(_ manager: CropQuoteManager, didGet cropQuote: [CropQuote]) -> Void
    func manager(_ manager: CropQuoteManager, didFailWith error: Error) -> Void
}
struct CropQuoteManager {
    weak var delegate: CropQuoteManagerDelegate?
    func requestCropQuote(onCropName crop: String?, onCropID id: String?, skipDataAmout skip: String?, maxDataAmount max: String?, fromDate:String?, toDate:String?) {
        //let parameterArray = [crop, id, skip, max, fromDate, toDate]
        //Todo: Use associated enum to establish params
        Alamofire.request(ApiConstant.CropApi.url, method: .get).responseData { response in
            guard(response.result.error == nil) else {
                print("CommentManager Error: \(response.result.error)")
                return
            }
            do {
                guard let data = response.data else {
                    print("CommentManager Error: No data to decode.")
                    return
                }
                print(data)
                let cropQuoteArray = try JSONDecoder().decode([CropQuote].self, from: data)
                print("Msg From CommentManager: cropQuoteArray = \(cropQuoteArray)")
                DispatchQueue.main.async {
                    self.delegate?.manager(self, didGet: cropQuoteArray)
                }
            } catch {
                print("CommentManager Error: \(error)")
                DispatchQueue.main.async {
                    self.delegate?.manager(self, didFailWith: error)
                }
            }
        }
    }
}

