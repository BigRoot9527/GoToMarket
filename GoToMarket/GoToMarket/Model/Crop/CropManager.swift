//
//  CropManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol CropManagerDelegate: class {
    func manager(_ manager: CropManager, didGet cropQuote: [CropQuote]) -> Void
    func manager(_ manager: CropManager, didFailWith error: Error) -> Void
}

struct CropManager {
    weak var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    weak var delegate: CropManagerDelegate?
    private let provider = CropProvider()
    
    func getCropQuote(task: CropRequestProvider) {
        provider.getCropQuote(
            request: task,
            success: { cropQuotes in
                let quotesArray = self.cropValidate(fromCropArray: cropQuotes, ofTask: task)
                switch task {
                case .getHistoryQutoes:
                    self.delegate?.manager( self, didGet: quotesArray)
                case .getInitailQuotes:
                    self.resetAllData(with: quotesArray)
                case .getNewQuote:
                    self.updateDatabase(with: quotesArray)
                }
        }) { error in
            print("error from CropManager, getCropQuote: \(error)")
        }
    }
    
    private func updateDatabase(with newQuote: [CropQuote]) {
        container?.performBackgroundTask{ context in
            for quoteInfo in newQuote {
                _ = CropNew.findOrCreateQuote(matching: quoteInfo, in: context)
            }
            try? context.save()
            print(Date().timeIntervalSince1970)
            print("Task ended-------")
            self.printDatabaseStatistics()
        }
    }
    
    private func resetAllData(with newQuote: [CropQuote]) {
        container?.performBackgroundTask{ context in
            CropNew.deleteAllQuotes(in: context, sucess: {
                self.updateDatabase(with: newQuote.reversed())
            }, failure: { error in
                print("Error from CropManager, resetAllData: \(error)")
            })
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let quoteCount = (try?context.fetch(CropNew.fetchRequest()))?.count {
                    print("Database count: \(quoteCount)")
                }
            }
        }
    }
    
    private func cropValidate(
        fromCropArray rawArray: [CropQuote],
        ofTask task:CropRequestProvider
        ) -> [CropQuote] {
        let correctMarketName = task.getMarket().rawValue
        let correctArray = rawArray.filter { aCropQuote -> Bool in
            aCropQuote.marketName == correctMarketName
        }
        return correctArray
    }
    
    
}
