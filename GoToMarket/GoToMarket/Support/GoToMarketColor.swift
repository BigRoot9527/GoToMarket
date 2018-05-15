//
//  GoToMarketColor.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

enum GoToMarketColor: String {
    
    case traditionalRed = "CA3738"
    case traditionalGreen = "61A763"
    case traditionalBlue = "3E82C2"
    case newDarkBlueGreen = "01585F"
    case newLightBlueGreen = "039393"
    case newWhite = "FFFCC4"
    case newGray = "F0EDBB"
    case newOrange = "FF3800"
    
    
    func color() -> UIColor {
        
        var cString: String = self.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
