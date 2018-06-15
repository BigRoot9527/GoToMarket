//
//  GoToMarketConstant.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/12.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

struct GoToMarketConstant {

    static let quotesRowHeight: CGFloat = 80.0

    static let quoteListsAllText: String = "全部"
    static let quoteListsFruitText: String = "水果"
    static let quoteListsVegeText: String = "蔬菜"

    static let cartNotificationName = Notification.Name("CartCount")
    static let weightNotificationName = Notification.Name("WeightType")

    static let emptyString: String = ""

    static let detailDropDownDuration: TimeInterval = 0.3

    static let marketPlaceholderPictureUrl: URL? = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Wroclaw_Daily_Market.jpg/640px-Wroclaw_Daily_Market.jpg")

    static let wikiForCorn: String = "玉米（學名：Zea mays）是一年生禾本科草本植物，是全世界總產量最高的重要糧食作物。同時也可以當作飼料使用，還有在生物科技產業作為乙醇燃料的原材料。而且玉米更在各個化工領域被大量利用著，做成塑膠等等不同的物品。"

    static let IQKeyboardDoneButtonText: String = "輸入"

    static let oneMonthChartLabelName: String = "近一月內批發均價"

    static let oneSeasonChartLabelName: String = "近三月內批發均價"
    
    static let loadingChartLabelText: String = "資料下載中...."

    static let lineCharLimitLineNamePrefix: String = "平均："

    static let lineCharLimitLineNamePostfix: String = "元／Kg"

    static let lineChartDescriptionString: String = "資料日期："

    static let noMarketsDataText: String = "沒有市場資料"

    static let alreadyLoadedMarket: String = " (目前設定)"

    static let plzMakeChoiceText: String = "請選擇"
    static let resetCurrentChoiceText: String = "重設"

    static let informationSourceText: String = "資料來源"

    static let nowInitText: String = "正在初始化"

    static let nowLoadingText: String = "正在下載"

    static let nowUpdatingText: String = "正在更新"

    static let finishLoadingText: String = "下載完成"

    static let finishUpdatingText: String = "更新完成"

    static let failUpdatingText: String = "更新失敗"

    static let failLoadingText: String = "下載失敗"

    static let dataSourceText: String = "資料"

    static let allowEnterButtonTitle: String = "確定"

    static let plzChooseAMarketWarning: String = "請選擇資料來源市場"

    static let itemTypeNameForCrops: String = "『農作物』"

    static let itemTypeCoreDataNameForCrops: String = "crop"

    static let kgWeightTypeButtonString: String = "元／公斤"

    static let tgWeightTypeButtonString: String = "元／台斤"

    static let calculateCostTextFieldError: String = "大於 0 之整數"

    static let calculateWeightTextFieldError: String = "大於 0 之數字"

    static let cropBasicNSSortDecriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "note.sellingPrice", ascending: true)]

    static let noteBasicNSSortDecriptor: [NSSortDescriptor] = [NSSortDescriptor(key: "isFinished", ascending: true), NSSortDescriptor(key: "sellingPrice", ascending: true)]

    static let cancleButtonTitleKey: String = "cancelButton"

    static let cancleButtonTitleValue: String = "取消"
}
