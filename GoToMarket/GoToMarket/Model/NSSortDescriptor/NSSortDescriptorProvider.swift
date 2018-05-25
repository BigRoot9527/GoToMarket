//
//  NSSortDescriptorProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation


struct NSSortDescriptorProvider {

    func getNSSortDescriptor(sortButtons:[SortButton]) -> [NSSortDescriptor] {
        
        var descriptorArray: [NSSortDescriptor] = []
        
        for sortButton in sortButtons {
            
            guard let isAcending = sortButton.getAcendingStyle() else {
                continue
            }
            
            descriptorArray.append(NSSortDescriptor(
                key: sortButton.representAttribute,
                ascending: isAcending))
        }
        
        return descriptorArray
    }
}
