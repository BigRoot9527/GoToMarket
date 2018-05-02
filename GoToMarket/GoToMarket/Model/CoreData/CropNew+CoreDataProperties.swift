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


extension CropNew {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropNew> {
        return NSFetchRequest<CropNew>(entityName: "CropNew")
    }

    @NSManaged public var date: String?
    @NSManaged public var cropCode: String?
    @NSManaged public var cropName: String?
    @NSManaged public var marketName: String?
    @NSManaged public var averagePrice: Float

}
