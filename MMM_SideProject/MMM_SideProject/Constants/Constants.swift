//
//  Constants.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/11/24.
//

import UIKit
import RealmSwift
import Realm

public enum ColorConst {
    static let mainColorString = "4300D1"
    static let grayColorString = "767676"
    static let blackColorString = "111111"
}

public enum FontConst {
    static let mainFont = "Moneygraphy-Pixel"
}

public enum CreateType : String, PersistableEnum {
    case total
    case income
    case expend
}

public enum ButtonType : Int {
    case total = 0
    case income = 1
    case expend = 2
}

public enum DateButtonType {
    case increase
    case decrease
}

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
        if (month.isDecreaseYear) {
            year -= 1
        }
        
        month -= 1
        
        if (month == 0) { month = 12 }
    }
    
    mutating func increase() {
        if (month.isIncreaseYear) {
            year += 1
        }
        
        month += 1
        
        if (month == 13) { month = 1 }
    }
}
