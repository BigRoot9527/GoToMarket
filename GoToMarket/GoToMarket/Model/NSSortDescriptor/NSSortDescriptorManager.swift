//
//  NSSortDescriptorManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

struct NSSortDescriptorManager {
    
    private let provider = NSSortDescriptorProvider()
    
    func getOrderedNSSortDescriptor(
        sortButtons:[SortButton],
        itemType:TaskKeys
        ) -> [NSSortDescriptor] {
        
        let sortDescriptorArray = provider.getNSSortDescriptor(sortButtons: sortButtons)
        
        switch itemType {
        case .crop:
            
            return sortDescriptorArray
            
        default:
            
            return [NSSortDescriptor(key: nil, ascending: true)]
        }
    }
}
