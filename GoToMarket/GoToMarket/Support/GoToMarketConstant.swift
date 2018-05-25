//
//  GoToMarketConstant.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/12.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class GoToMarketConstant {
    
    static let quotesRowHeight: CGFloat = 70.0
    
//    static let detailFoldedRowHeight: CGFloat = 755.0
//    
//    static let detailExpendRowHeight: CGFloat = 910.0
    static let cartNotificationName = Notification.Name("CartCount")
    
    static let emptyString: String = ""
    
    static let detailDropDownDuration: TimeInterval = 0.3
    
    static let marketPlaceholderPictureUrl: URL? = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Wroclaw_Daily_Market.jpg/640px-Wroclaw_Daily_Market.jpg")
    
    static let oneMonthChartLabelName: String = "近一月內批發均價"
    
    static let oneSeasonChartLabelName: String = "近三月內批發均價"
    
    static let lineCharLimitLineNamePrefix: String = "平均："
    
    static let lineCharLimitLineNamePostfix: String = "元／Kg"
    
    static let lineChartDescriptionString: String = "資料顯示日期："
    
    static let noMarketsDataText: String = "沒有市場資料"
    
    static let alreadyLoadedMarket: String = " (目前設定)"
    
    static let plzMakeChoiceText: String = "請選擇"
    
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
    
    static let cropBasicNSSortDecriptor: NSSortDescriptor = NSSortDescriptor(key: "newAveragePrice", ascending: true)
    
    
    
}
