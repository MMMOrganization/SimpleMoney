//
//  YearMonth.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation

struct YearMonth {
    var year : Int
    var month : Int
    
    init() {
        (self.year, self.month) = Date.currentDate
    }
    
    func toString() -> String {
        return "\(self.year)년 \(self.month)월"
    }
    
    mutating func decrease() {
        if (month.isDecreaseYear) { year -= 1 }
        month -= 1
        if (month == 0) { month = 12 }
    }
    
    mutating func increase() {
        if (month.isIncreaseYear) { year += 1 }
        month += 1
        if (month == 13) { month = 1 }
    }
}
