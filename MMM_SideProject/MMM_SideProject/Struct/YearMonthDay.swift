//
//  YearMonth.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation

struct YearMonthDay {
    private var year : Int
    private var month : Int
    private var day : Int
    
    init() {
        (self.year, self.month, self.day) = Date.currentDate
    }
}

extension YearMonthDay {
    func toStringYearMonthDay() -> String {
        return "\(self.year)-\(self.month < 10 ? "0" + String(self.month) : String(self.month))-\(self.day < 10 ? "0" + String(self.day) : String(self.day))"
    }
    
    func toStringYearMonth() -> String {
        return "\(self.year)년 \(self.month)월"
    }
    
    /// Realm 정규화 매칭을 위해서 필요한 정보
    func toStringYearMonthForRealmData() -> String {
        return "\(self.year)-\(self.month < 10 ? "0" + String(self.month) : String(self.month))"
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    func getMonth() -> Int {
        return self.month
    }
    
    func getDay() -> Int {
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
