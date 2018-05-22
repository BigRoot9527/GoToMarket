//
//  Extension UIStoryboard.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func tabBar() -> UIStoryboard {
        return UIStoryboard(name: "TabBar", bundle: nil)
    }
    
    static func quotes() -> UIStoryboard {
        return UIStoryboard(name: "Quotes", bundle: nil)
    }
    
    static func notes() -> UIStoryboard {
        return UIStoryboard(name: "Notes", bundle: nil)
    }
    
    static func settings() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
    
    static func marketSetting() -> UIStoryboard {
        return UIStoryboard(name: "MarketSetting", bundle: nil )
    }
    
    static func loading() -> UIStoryboard {
        return UIStoryboard(name: "Loading", bundle: nil )
    }
    
    
    
}
