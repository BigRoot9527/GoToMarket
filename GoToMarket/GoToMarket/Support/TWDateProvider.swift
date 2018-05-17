//
//  TWDateProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

class TwDateProvider {
    
    static func getUpdateStartDateString(fromLastDate lastUpdateDate: Date?) -> String {
        let today = Date()
        guard
            let lastDay = lastUpdateDate,
            let days = daysBetween(lastDate: lastDay, newDate: today),
            days < 7 else {
            return getDaysAgoString(fromDaysAgo: 7)
        }
        return twDateConverter(inputDate: lastDay)
    }

    static func getTodayString() -> String {
        let today = Date()
        return twDateConverter(inputDate: today)
    }
    
    static func getMonthsAgoString(fromMonthsAgo month: Int) -> String {
        guard let MonthsAgo = Calendar.current.date(byAdding: .month, value: -month, to: Date()) else {
            return "error: getMonthsAgoString Fail"
        }
        return twDateConverter(inputDate: MonthsAgo)
    }
    
    private static func getDaysAgoString(fromDaysAgo day: Int) -> String {
        guard let daysAgo = Calendar.current.date(byAdding: .weekOfYear, value: -day, to: Date()) else {
            return "error: getDaysAgoString Fail"
        }
        return twDateConverter(inputDate: daysAgo)
    }
    
    private static func daysBetween(lastDate: Date, newDate: Date) -> Int? {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.day], from: lastDate, to: newDate)
        
        return components.day
    }
    
    private static func twDateConverter(inputDate: Date) -> String {
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
