//
//  IngredientStruct.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

enum IngredientTypes: String {
    case Crop = "CropDatas"
}

struct IngredientItem {
    let uniqueItemCode: String
    let listUuid: String
    let itemName: String
    let itemType: IngredientTypes
    let savedPrice: Double
    var buyingKG: Double
    var done: Bool
    var newPriceFromQuote: Double?
    var actualPrice: Double?
    let parentList: BuyingListItem
}
