//
//  Ingredient+CoreDataProperties.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var actualPricePerKG: Double
    @NSManaged public var buyingKg: Double
    @NSManaged public var done: Bool
    @NSManaged public var itemName: String?
    @NSManaged public var savedPridictPricePerKG: Double
    @NSManaged public var itemCodeUnique: String?
    @NSManaged public var itemType: String?
    @NSManaged public var listUuid: String?
    @NSManaged public var list: BuyingList?

}
