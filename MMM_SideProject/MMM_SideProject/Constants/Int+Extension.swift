//
//  Int+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation

extension Int {
    /// month가 12월에서 추가됐을 때 year가 올라감.
    var isIncreaseYear : Bool {
        return (self == 12 ? true : false)
    }
    
    /// month가 1월에서 감소됐을 때 year가 감소함.
    var isDecreaseYear : Bool {
        return (self == 1 ? true : false)
    }
    
    var toCurrency : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        let stringValue = formatter.string(from: NSNumber(value: self)) ?? ""
        return stringValue + "원"
    }
}
