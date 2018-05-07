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
    class func fetchQuote(
        matching quoteInfo: CropQuote,
        in context: NSManagedObjectContext
        ) -> CropDatas?
    {
        let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
        request.predicate = NSPredicate(format: "(cropCode = %@) AND (marketName = %@)", quoteInfo.cropCode, quoteInfo.marketName)
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
        if let fetchedQuote = self.fetchQuote(matching: quoteInfo, in: context)
        {
            fetchedQuote.averagePrice = quoteInfo.averagePrice
            fetchedQuote.date = quoteInfo.date
            fetchedQuote.cropName = quoteInfo.cropName
            return fetchedQuote
        }
        else
        {
            let newCrop = CropDatas(context: context)
            newCrop.cropCode = quoteInfo.cropCode
            newCrop.cropName = quoteInfo.cropName
            newCrop.averagePrice = quoteInfo.averagePrice
            newCrop.date = quoteInfo.date
            newCrop.marketName = quoteInfo.marketName
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

}
