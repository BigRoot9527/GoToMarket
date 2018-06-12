//
//  CropNewQuotesProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CropProvider {

    private weak var httpClient = HttpClient.shared
    private let decoder = JSONDecoder()

    private weak var container: NSPersistentContainer? = AppDelegate.shared.persistentContainer

    func getCropQuote(
        request: CropRequest,
        success: @escaping([CropQuote]) -> Void,
        failure: @escaping(Error) -> Void ) {

        httpClient?.request(request,
        success: { data in
            do {
                print("Task started-------")
                print(Date().timeIntervalSince1970)
                let response = try self.decoder.decode([CropQuote].self, from: data)
                success(response)
            } catch {
                print("Error when CropProvider parsing Json")
            }
        },
        failure: { error in
            print("Error from CropProvider: \(error)")
            failure(error)
        })
    }

    func updateDatabase(with newQuote: [CropQuote],
                        success: @escaping () -> Void,
                        failure: @escaping (Error) -> Void) {
        container?.performBackgroundTask { context in
            for quoteInfo in newQuote {
                _ = CropDatas.updateOrCreateQuote(matching: quoteInfo, in: context)
            }
            do {
                try context.save()
            } catch {
                failure(error)
            }
            print(Date().timeIntervalSince1970)
            print("Task ended-------")
            self.printDatabaseStatistics()
            success()
        }
    }

    func resetAllData(with newQuote: [CropQuote],
                      success: @escaping () -> Void,
                      failure: @escaping (Error) -> Void) {
        container?.performBackgroundTask { context in
            CropDatas.deleteAllQuotes(
                in: context,
                sucess: {
                self.updateDatabase(
                    with: newQuote.reversed(),
                    success: { success() },
                    failure: { error in failure(error) })
            },
                failure: { error in failure(error)
            })
        }
    }

    func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let quoteCount = (try?context.fetch(CropDatas.fetchRequest()))?.count {
                    print("Database count: \(quoteCount)")
                }
            }
        }
    }

    func marketValidate(
        fromCropArray rawArray: [CropQuote],
        ofMarketString market: String
        ) -> [CropQuote] {
        let correctArray = rawArray.filter { aCropQuote -> Bool in
            aCropQuote.marketName == market
        }
        return correctArray
    }

    func getCropData(fromItemCode code: String, itemType type: String) -> CropDatas? {
        if let context = container?.viewContext {

            let cropData = CropDatas.fetchCropQuoteFromCode(
                matchingCode: code,
                matchingType: type,
                in: context)

            return cropData
        }

        return nil
    }
}
