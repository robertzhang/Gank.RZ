//
//  String+Extension.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/6.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import Foundation

// 这里在使用的时候需要注意，确保当前的string是 yyy-MM-dd格式的字符串
extension String {
    var componet: NSDateComponents {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let date = timeFormatter.dateFromString(self)
        
        return  NSCalendar.currentCalendar().components(
            [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day],
            fromDate: date!)
    }
    
    func getDay() -> String {
        return String(componet.day)
    }
    
    func getMonth() -> String {
        return String(componet.month)
    }
    
    func getYear() -> String {
        return String(componet.year)
    }
    
    func getMonthDay() -> String {
        return getMonth() + "月" + getDay() + "日"
    }
}