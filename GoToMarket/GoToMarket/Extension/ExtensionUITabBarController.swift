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
    
    func getTabBarCenterPoint() -> CGPoint {
        
        let centerUITabBarButtonFrame = self.orderedTabBarItemViews()[1].frame
        
        let centerPoint = CGPoint(x: centerUITabBarButtonFrame.width / 2, y: centerUITabBarButtonFrame.height / 2)
        
        return centerPoint
    }
}


