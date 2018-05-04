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
    
    class func findOrCreateNote(
        matching cropData: CropDatas,
        in context: NSManagedObjectContext
        ) -> UserNotes
    {
        let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
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
                return maches[0]
            }
        } catch {
            print(error)
        }
        let newNote = UserNotes(context: context)
        newNote.favorite = false
        newNote.cropCode = cropData.cropCode
        newNote.customMutipler = 2.0
        newNote.muliplerWeight = 1.0
        newNote.cropData = cropData
        return newNote
    }

}
