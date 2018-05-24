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
        //Note itemCode是必須的，因為cropData被刪掉重建後，雖然為同一個作物，
        //但因自動編號已經被改掉，所以無法直接順利的配對回去(已經是不同的cropData了)
        request.predicate = NSPredicate(
            format: "(itemCode = %@) AND (itemType = %@)",
            cropData.cropCode,
            cropData.itemType)
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("UserNotes NSMO Error: matches > 1 \($0)")
                    }
                }
                //單向: 用cropData找Note, 不能用note找cropData
                maches[0].buyingAmount = NoteConstant.initialBuyingAmount
                maches[0].isFinished = NoteConstant.initialIsFinished
                maches[0].isInCart = NoteConstant.initialIsInCart
                
                maches[0].customMutipler = NoteConstant.initailMultipler
                maches[0].muliplerWeight = NoteConstant.initailMultiplerWeight
                
                maches[0].cropData = cropData
                return maches[0]
            }
        } catch {
            print(error)
        }
        let newNote = UserNotes(context: context)
        newNote.buyingAmount = NoteConstant.initialBuyingAmount
        newNote.isFinished = NoteConstant.initialIsFinished
        newNote.isInCart = NoteConstant.initialIsInCart
        
        newNote.customMutipler = NoteConstant.initailMultipler
        newNote.muliplerWeight = NoteConstant.initailMultiplerWeight
        
        newNote.cropData = cropData
        newNote.itemType = cropData.itemType
        newNote.itemCode = cropData.cropCode
        return newNote
    }
    
    class func fetchNote(
        matching cropCode: String,
        in context: NSManagedObjectContext
        ) -> UserNotes?
    {
        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
        request.predicate = NSPredicate(format: "(cropCode = %@)", cropCode)
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
    
    //MARK: managed function
    func setInCart(isInCart: Bool, inContext context: NSManagedObjectContext?) throws {
        
        guard let iputContext = context else { throw GoToMarketError.ValidContext }
        
        self.isInCart = isInCart
        self.isFinished = NoteConstant.initialIsFinished
        self.buyingAmount = NoteConstant.initialBuyingAmount

        try iputContext.save()
    }
    
    class func setFavoriteState(
        matching cropCode: String,
        toState bool: Bool,
        in context: NSManagedObjectContext
        ) throws -> UserNotes
    {
        guard let fetchedNote = self.fetchNote(matching: cropCode, in: context) else { throw GoToMarketError.FetchError }
        fetchedNote.isInCart = bool
        return fetchedNote
    }
    
    class func getFavoriteState(
        matching cropCode: String,
        in context: NSManagedObjectContext
        ) throws -> Bool
    {
        guard
            let note = self.fetchNote(matching: cropCode, in: context)
            else { throw GoToMarketError.FetchError }
        return note.isInCart
    }
    
    class func getPredictPrice(
        matching cropCode: String,
        in context: NSManagedObjectContext
        ) throws -> Double
    {
        guard
            let note = self.fetchNote(matching: cropCode, in: context),
            let quote = note.cropData?.newAveragePrice
            else { throw GoToMarketError.FetchError }
        let multipler = note.customMutipler
        return multipler * quote
    }
    
    class func setMutiplerAndWeightTrainModel(
        //概念：原本存有mutipler跟weight，只要給新的mutipler(某天的實際購買價/某天的行情)即可train
        matching cropCode: String,
        actualPricePerKG: Double,
        in context: NSManagedObjectContext) throws -> UserNotes
    {
        guard
            let note = self.fetchNote(matching: cropCode, in: context),
            //quoteBuyingDay ~> V1.0使用當日行情(假設使用者是當天買的時候就校正)，未來使用API打使用者指定日期(今日or之前)，取得特定市場該作物的當日行情
            let quoteBuyingDay = note.cropData?.newAveragePrice
            //沒有cropData => 無法取得現在行情價 => 無法計算現在的mutipler => 無法machine learning
        else { throw GoToMarketError.FetchError }
        
        let inputMutipler = actualPricePerKG / quoteBuyingDay
        let originMutipler = note.customMutipler
        let originWeight = note.muliplerWeight
        //handle非預設的第一次input
        if originWeight == NoteConstant.initailMultiplerWeight
        {
            note.muliplerWeight = NoteConstant.firstInputMultiplerWeight
            note.customMutipler = inputMutipler
            return note
        }
        let confidenceIntervel = originMutipler * NoteConstant.confidenceConstant
        let inputWeight: Double =
            ( NoteConstant.maximunWeightPerTrain
                - (exp(fabs(inputMutipler - originMutipler) - confidenceIntervel)))
        let newWeight = originWeight + inputWeight
        let newMutipler =
            ((originMutipler * originWeight) + (inputMutipler * inputWeight)) / newWeight
        note.customMutipler = newMutipler
        note.muliplerWeight = newWeight
        return note
    }
    
}
