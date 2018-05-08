//
//  Ingredient+CoreDataClass.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


public class Ingredient: NSManagedObject {
    
    class func createNewIngredient(
        priceKgWillSave price: Double,
        willBuyKg buyingKg: Double,
        fromItemName itemName: String,
        fromUniqueItemCode uniqueItemcode: String,
        fromItemType itemtype: String,
        listUuid listID: String,
        in context: NSManagedObjectContext
        ) -> Ingredient
    {
        let newIngredient = Ingredient(context: context)
        newIngredient.savedPridictPricePerKG = price
        newIngredient.buyingKg = buyingKg
        newIngredient.done = IngredientConstant.initialIngredientDone
        newIngredient.itemName = itemName
        newIngredient.actualPricePerKG = IngredientConstant.initialIngredientActualPrice
        newIngredient.itemCodeUnique = uniqueItemcode
        newIngredient.itemType = itemtype
        newIngredient.listUuid = listID
        return newIngredient
    }
    
    

}
