//
//  ExtensionUITabBarController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/31.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func orderedTabBarItemViews() -> [UIView] {
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
        return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
    }
}


