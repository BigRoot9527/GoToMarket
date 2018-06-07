//
//  CropNew+CoreDataClass.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/1.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData

public class CropDatas: NSManagedObject
{
    class func fetchQuote(matching quoteInfo: CropQuote,
                          in context: NSManagedObjectContext) -> CropDatas? {
        
        let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
        request.predicate = NSPredicate(
            format: "(cropCode = %@) AND (marketName = %@) AND (itemType = %@)",
            quoteInfo.cropCode,
            quoteInfo.marketName,
            GoToMarketConstant.itemTypeCoreDataNameForCrops)
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("CropDatas NSMO Error: matches > 1 \($0)")
                    }
                }
                return maches[0]
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    class func updateOrCreateQuote(
        matching quoteInfo: CropQuote,
        in context: NSManagedObjectContext
        ) -> CropDatas
    {
        if
            let fetchedQuote = self.fetchQuote(matching: quoteInfo, in: context),
            let note = fetchedQuote.note
        {
            guard fetchedQuote.date != quoteInfo.date || fetchedQuote.newAveragePrice != quoteInfo.averagePrice else {
                return fetchedQuote
            }
            fetchedQuote.lastAveragePrice = fetchedQuote.newAveragePrice
            fetchedQuote.newAveragePrice = quoteInfo.averagePrice
            fetchedQuote.date = quoteInfo.date
            fetchedQuote.cropName = quoteInfo.cropName
            note.sellingPrice = quoteInfo.averagePrice * note.customMutipler
            return fetchedQuote
        }
        else
        {
            let newCrop = CropDatas(context: context)
            newCrop.cropCode = quoteInfo.cropCode
            newCrop.cropName = quoteInfo.cropName
            newCrop.lastAveragePrice = quoteInfo.averagePrice
            newCrop.newAveragePrice = quoteInfo.averagePrice
            newCrop.isFruit = quoteInfo.cropCode.isNumberOnSecondCharactor()
            newCrop.date = quoteInfo.date
            newCrop.marketName = quoteInfo.marketName
            newCrop.itemType = GoToMarketConstant.itemTypeCoreDataNameForCrops
            newCrop.note = UserNotes.findOrCreateNoteFromData(matching: newCrop, in: context)
            return newCrop
        }
    }
    
    class func deleteAllQuotes(
        in context: NSManagedObjectContext,
        sucess: () -> Void,
        failure: (Error) -> Void)
    {
        let request: NSFetchRequest<NSFetchRequestResult> = CropDatas.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDeleteRequest)
            sucess()
        } catch {
            failure(error)
        }
    }
    
    
    class func fetchCropQuoteFromCode(matchingCode itemCode: String,
                                      matchingType itemType: String,
                                      in context: NSManagedObjectContext) -> CropDatas? {
        
        let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
        request.predicate = NSPredicate(
            format: "(cropCode = %@) AND (itemType = %@)", itemCode, itemType )
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("CropDatas NSMO Error: matches > 1 \($0)")
                    }
                }
                return maches[0]
            }
        } catch {
            print(error)
        }
        return nil
    }

}
