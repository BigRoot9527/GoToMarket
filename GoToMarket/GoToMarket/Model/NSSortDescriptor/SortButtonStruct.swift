//
//  SortButtonStruct.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol SortParametersGettable {
    
    var representAttribute: String { get set }
    
    func getAcendingStyle() -> Bool?
}

struct SortButton: SortParametersGettable {
    
    var state: ToolButtonState
    var representAttribute: String
    
    enum ToolButtonState {
        
        case ascending, descending, none
        
        mutating func next() {
            
            switch self {
                
            case .ascending:
                self = .descending
                
            case .descending:
                self = .none
                
            case .none:
                self = .ascending
            }
        }
    }
    
    func getTintColor() -> UIColor {
        
        switch state {
            
        case .ascending:
            return GoToMarketColor.sortButtonAcendingColor.color()
            
        case .descending:
            return GoToMarketColor.sortButtonDecendingColor.color()
            
        case .none:
            return GoToMarketColor.sortButtonNoneColor.color()
        }
    }
    
    func getAcendingStyle() -> Bool? {
        
        switch state {
        case .ascending:
            return true
        case .descending:
            return false
        case .none:
            return nil
        }
    }
}
