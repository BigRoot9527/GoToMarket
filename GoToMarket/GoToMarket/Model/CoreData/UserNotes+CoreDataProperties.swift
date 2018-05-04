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

    @NSManaged public var customMutipler: Float
    @NSManaged public var muliplerWeight: Float
    @NSManaged public var favorite: Bool
    @NSManaged public var cropData: CropDatas?

}
