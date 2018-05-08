//
//  BuyingList+CoreDataClass.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


public class BuyingList: NSManagedObject {
    
    class func fetchUniqueList(
        matchingUuid uuid: String,
        in context: NSManagedObjectContext
        ) -> BuyingList?
    {
        let request: NSFetchRequest<BuyingList> = BuyingList.fetchRequest()
        request.predicate = NSPredicate(format: "uuid = %@", uuid)
        do {
            let maches = try context.fetch(request)
            if maches.count > 0 {
                if maches.count > 1 {
                    maches.forEach {
                        print("BuyingList NSMO Error: matches > 1 \($0)")
                    }
                }
                return maches[0]
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    class func fetchListsOfDay(
        matchingDate createTime: NSDate,
        in context: NSManagedObjectContext
        ) -> [BuyingList]?
    {
        let request: NSFetchRequest<BuyingList> = BuyingList.fetchRequest()
        request.predicate = NSPredicate(format: "createTime = %@", createTime)
        do {
            let maches = try context.fetch(request)
            return maches
        } catch {
            print(error)
        }
        return nil
    }
    
    class func createNewList(
        expectedBudget budget: Int32,
        createTime time: NSDate,
        listName name: String,
        totalQuota quota: Int16,
        uniqueId uuid: String,
        withIngredients ingredients: [Ingredient]?,
        in context: NSManagedObjectContext
        ) -> BuyingList
    {
        let newList = BuyingList(context: context)
        newList.alldone = BuyingListConstant.initalListAllDone
        newList.budget = budget
        newList.createTime = time
        newList.listName = name
        newList.quota = quota
        newList.uuid = uuid
        if let ingredientsArray = ingredients {
            let set = NSSet(array: ingredientsArray)
            newList.addToIngredients(set)
        } else {
            newList.ingredients = nil
        }
        return newList
    }

}
