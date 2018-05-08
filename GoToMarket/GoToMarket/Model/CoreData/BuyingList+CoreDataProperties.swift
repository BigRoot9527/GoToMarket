//
//  BuyingList+CoreDataProperties.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


extension BuyingList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuyingList> {
        return NSFetchRequest<BuyingList>(entityName: "BuyingList")
    }

    @NSManaged public var alldone: Bool
    @NSManaged public var budget: Int32
    @NSManaged public var createTime: NSDate?
    @NSManaged public var listName: String?
    @NSManaged public var quota: Int16
    @NSManaged public var uuid: String?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension BuyingList {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}
