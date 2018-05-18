//
//  ExtensionArray.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/18.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation


extension Array where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Array where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(Int(total)) / Double(count)
    }
}

extension Array where Element: FloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
