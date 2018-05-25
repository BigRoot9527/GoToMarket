//
//  ExtensionString.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/16.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

extension String {
    
    //getting string array through regular expression
    
    func matchesString(fromRegex regex: String) -> [String]? {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
    
    func trimed() -> String {
        
        let targetOne = "-"
        let targetTwo = "("
        
        let trimedOne = self.components(separatedBy: targetOne)[0]
        
        if trimedOne.range(of:targetTwo) != nil {
            let trimedTwo = trimedOne.components(separatedBy: targetTwo)[0]
            return trimedTwo
        } else {
            return trimedOne
        }
    }
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    func trimedEscaping() -> String {
        let trimedR = self.replacingOccurrences(of: "\\r", with: "")
        let trimedN = trimedR.replacingOccurrences(of: "\\n", with: "\n")
        return trimedN
    }
}
