//
//  UserNotes+CoreDataClass.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


public class UserNotes: NSManagedObject {
    
    class func findOrCreateNoteFromData(
        matching cropData: CropDatas,
        in context: NSManagedObjectContext
        ) -> UserNotes
    {
        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
        //cropCode是必須的，因為cropData被刪掉重建後，雖然為同一個作物，
        //但因自動編號已經被改掉，所以無法直接順利的配對會去(已經是不同的cropData了)
        request.predicate = NSPredicate(format: "(cropCode = %@)", cropData.cropCode)
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("UserNotes NSMO Error: matches > 1 \($0)")
                    }
                }
                maches[0].cropData = cropData
                maches[0].customMutipler = NoteConstant.initailMultipler
                maches[0].muliplerWeight = NoteConstant.initailMultiplerWeight
                return maches[0]
            }
        } catch {
            print(error)
        }
        let newNote = UserNotes(context: context)
        newNote.favorite = NoteConstant.initailFavorite
        newNote.cropCode = cropData.cropCode
        newNote.customMutipler = NoteConstant.initailMultipler
        newNote.muliplerWeight = NoteConstant.initailMultiplerWeight
        newNote.cropData = cropData
        return newNote
    }
    
    class func fetchNote(
        matching quoteInfo: CropQuote,
        in context: NSManagedObjectContext
        ) -> UserNotes?
    {
        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
        request.predicate = NSPredicate(format: "(cropCode = %@)", quoteInfo.cropCode)
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("UserNotes NSMO Error: matches > 1 \($0)")
                    }
                }
                return maches[0]
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    class func setFavoriteState(
        matching quoteInfo: CropQuote,
        toState bool: Bool,
        in context: NSManagedObjectContext
        )
    {
        guard let fetchedNote = self.fetchNote(matching: quoteInfo, in: context) else { return }
        fetchedNote.favorite = bool
    }
    
    class func getFavoriteState(
        matching quoteInfo: CropQuote,
        in context: NSManagedObjectContext
        ) throws -> Bool
    {
        guard
            let note = self.fetchNote(matching: quoteInfo, in: context)
            else { throw GoToMarketError.FetchError }
        return note.favorite
    }
    
    class func setCropMutiplerAndWeight(
        matching quoteInfo: CropQuote,
        withNewMutipler mutipler: Double,
        withNewWeight weight: Double,
        in context: NSManagedObjectContext
        )
    {
        guard let note = self.fetchNote(matching: quoteInfo, in: context) else { return }
        note.customMutipler = mutipler
        note.muliplerWeight = weight
    }
    
    class func getPredictPrice(
        matching quoteInfo: CropQuote,
        in context: NSManagedObjectContext
        ) throws -> Double
    {
        guard
            let note = self.fetchNote(matching: quoteInfo, in: context),
            let quote = note.cropData?.averagePrice
            else { throw GoToMarketError.FetchError }
        let multipler = note.customMutipler
        return multipler * quote
    }
    
}
