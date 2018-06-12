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
        ) -> UserNotes {

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
                let machNote = maches[0]

                machNote.buyingAmount = NoteConstant.initialBuyingAmount
                machNote.isFinished = NoteConstant.initialIsFinished
                machNote.isInCart = NoteConstant.initialIsInCart

                machNote.customMutipler = NoteConstant.initailMultipler
                machNote.muliplerWeight = NoteConstant.initailMultiplerWeight
                machNote.sellingPrice = cropData.newAveragePrice * NoteConstant.initailMultipler

                machNote.cropData = cropData
                return machNote
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
        newNote.sellingPrice = cropData.newAveragePrice * NoteConstant.initailMultipler

        newNote.cropData = cropData
        newNote.itemType = cropData.itemType
        newNote.itemCode = cropData.cropCode
        return newNote
    }

    class func fetchNote(
        matching cropCode: String,
        in context: NSManagedObjectContext
        ) -> UserNotes? {

        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
        request.predicate = NSPredicate(format: "(itemCode = %@)", cropCode)
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

    class func countCartNotes(in context: NSManagedObjectContext ) -> Int {

        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
        request.predicate = NSPredicate(format: "(isInCart = true) AND (cropData != nil) AND (isFinished = false)")

        do {

            let maches = try context.fetch(request)
            return maches.count

        } catch {
            print(error)
        }
        return 0
    }

    class func resetMultipler(
        toItemCode code: String,
        in context: NSManagedObjectContext ) throws -> UserNotes {

        guard
            let note = self.fetchNote(matching: code, in: context),
            let cropData = note.cropData
            else { throw GoToMarketError.fetchError }

        note.muliplerWeight = NoteConstant.firstInputMultiplerWeight

        note.customMutipler = NoteConstant.initailMultipler

        note.sellingPrice = cropData.newAveragePrice * NoteConstant.initailMultipler

        try context.save()

        return note
    }

    class func trainModelWithActualPrice(
        //概念：原本存有mutipler跟weight，只要給新的mutipler(某天的實際購買價/某天的行情)即可train
        matching cropCode: String,
        actualPricePerKG: Double,
        in context: NSManagedObjectContext) throws -> UserNotes {
        guard
            let note = self.fetchNote(matching: cropCode, in: context),
            //quoteBuyingDay ~> V1.0使用當日行情(假設使用者是當天買的時候就校正)，未來使用API打使用者指定日期(今日or之前)，取得特定市場該作物的當日行情
            let cropData = note.cropData
            //沒有cropData => 無法取得現在行情價 => 無法計算現在的mutipler => 無法machine learning
        else { throw GoToMarketError.fetchError }

        let inputMutipler = actualPricePerKG / cropData.newAveragePrice
        let originMutipler = note.customMutipler
        let originWeight = note.muliplerWeight
        //handle非預設的第一次input
        if originWeight == NoteConstant.initailMultiplerWeight {
            note.muliplerWeight = NoteConstant.firstInputMultiplerWeight
            note.customMutipler = inputMutipler
            note.sellingPrice = cropData.newAveragePrice * inputMutipler
            try context.save()

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
        note.sellingPrice = cropData.newAveragePrice * newMutipler
        try context.save()

        return note
    }

    // MARK: - self managed function
    func setInCart(isInCart: Bool, inContext context: NSManagedObjectContext?) throws {

        guard let iputContext = context else { throw GoToMarketError.validContext }

        self.isInCart = isInCart
        self.isFinished = NoteConstant.initialIsFinished
        self.buyingAmount = NoteConstant.initialBuyingAmount

        try iputContext.save()
    }

}
