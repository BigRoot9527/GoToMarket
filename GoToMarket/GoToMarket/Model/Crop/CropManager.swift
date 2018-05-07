//
//  CropManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation


protocol CropManagerDelegate: class {
    func manager(_ manager: CropManager, didGet cropQuote: [CropQuote]) -> Void
    func manager(_ manager: CropManager, didFailWith error: Error) -> Void
}

struct CropManager {
    
    weak var delegate: CropManagerDelegate?
    private let provider = CropProvider()
    
    func accessCropQuote(task: CropRequestProvider) {
        provider.getCropQuote(
            request: task,
            success: { cropQuotes in
                let quotesArray = self.provider.cropValidate(fromCropArray: cropQuotes, ofTask: task)
                switch task {
                case .getHistoryQutoes:
                    self.delegate?.manager(self, didGet: quotesArray)
                case .getInitailQuotes:
                    self.provider.resetAllData(with: quotesArray)
                case .getNewQuote:
                    self.provider.updateDatabase(with: quotesArray)
                }
        }) { error in
            print("error from CropManager, getCropQuote: \(error)")
            self.delegate?.manager(self, didFailWith: error)
        }
    }
    
    
    
}
