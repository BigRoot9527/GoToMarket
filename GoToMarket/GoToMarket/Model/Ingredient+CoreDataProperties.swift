//
//  Ingredient+CoreDataProperties.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var buyingKg: Float
    @NSManaged public var done: Bool
    @NSManaged public var itemName: String?
    @NSManaged public var savedPrice: Float
    @NSManaged public var actualPrice: Float
    @NSManaged public var savedTime: NSDate?
    @NSManaged public var list: BuyingList?

}
