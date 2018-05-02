//
//  TWDateProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

class TwDateProvider {

    static func getTodayString() -> String {
        let today = Date()
        return TwDateConverter(inputDate: today)
    }
    
    static func getLastWeekString() -> String {
        guard let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else {
            return "error: getLastWeekString Fail"
        }
        return TwDateConverter(inputDate: lastWeek)
    }
    
    static func getLastMonthString() -> String {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else {
            return "error: getLastMonthString Fail"
        }
        return TwDateConverter(inputDate: lastMonth)
    }
    
    private static func TwDateConverter(inputDate: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from:inputDate)
        let month = calendar.component(.month, from:inputDate)
        let day = calendar.component(.day, from:inputDate)
        var newMonth = "", newDay = "", newYear = ""
        if (month < 10) {
            newMonth = "0" + String(month)
        } else {
            newMonth = String(month)
        }
        if (day < 10) {
            newDay = "0" + String(day)
        } else {
            newDay = String(day)
        }
        newYear = String(year - 1911)
        let strDate = newYear + "." + newMonth + "." + newDay
        return strDate
    }
}
