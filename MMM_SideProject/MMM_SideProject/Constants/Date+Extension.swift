//
//  Date+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation

extension Date {
    /// Y, M 을 관리하는 값 객체에 넘겨줄 타입 메소드
    static var currentDate : (Int, Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let dateIntegerList = formattedDate.split(separator: "-").map { Int(String($0))! }
        
        return (dateIntegerList[0], dateIntegerList[1])
    }
}
