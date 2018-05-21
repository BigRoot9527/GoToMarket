//
//  UserNotes+CoreDataProperties.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData


extension UserNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserNotes> {
        return NSFetchRequest<UserNotes>(entityName: "UserNotes")
    }

    @NSManaged public var customMutipler: Double
    @NSManaged public var muliplerWeight: Double
    @NSManaged public var isInChart: Bool
    @NSManaged public var itemCode: String
    @NSManaged public var isFinished: Bool
    @NSManaged public var buyingAmount: Int16
    @NSManaged public var itemType: String?
    @NSManaged public var cropData: CropDatas?

}
