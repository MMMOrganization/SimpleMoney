//
//  YearMonth.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation

struct YearMonth {
    private var year : Int
    private var month : Int
    private var day : Int?
    
    init() {
        (self.year, self.month) = Date.currentDate
    }
}

extension YearMonth {
    func toString() -> String {
        return "\(self.year)년 \(self.month)월"
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    func getMonth() -> Int {
        return self.month
    }
    
    func getDay() -> Int? {
        return self.day
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
    
    mutating func setDay(of day : Int) {
        self.day = day
    }
}
