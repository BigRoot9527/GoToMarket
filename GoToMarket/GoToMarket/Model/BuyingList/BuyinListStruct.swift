//
//  BuyinListStruct.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct BuyingListItem {
    let createTime: Date
    let uuid: String
    var listName: String
    var alldone: Bool
    var budget: Int32
    var quota: Int16
    var childIngredients: [IngredientItem]?
}
