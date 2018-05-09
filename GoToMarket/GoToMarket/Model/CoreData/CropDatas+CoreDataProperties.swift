//
//  CropNew+CoreDataProperties.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/1.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
//

import Foundation
import CoreData

extension CropDatas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropDatas> {
        return NSFetchRequest<CropDatas>(entityName: "CropDatas")
    }

    @NSManaged public var date: String
    @NSManaged public var cropCode: String
    @NSManaged public var cropName: String
    @NSManaged public var marketName: String?
    @NSManaged public var averagePrice: Double
    @NSManaged public var note: UserNotes?

}
