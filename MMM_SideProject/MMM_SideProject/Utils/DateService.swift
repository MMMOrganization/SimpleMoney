//
//  DateService.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/22/25.
//

import UIKit

struct DateService {
    private var ymd = YearMonthDay()
    
    /// YYYY-MM-DD 형식으로 반환해주는 계산 속성
    var yearmonthday : String {
        "\(ymd.getYear())-\(ymd.getMonth() < 10 ? "0" + String(ymd.getMonth()) : String(ymd.getMonth()))-\(ymd.getDay() < 10 ? "0" + String(ymd.getDay()) : String(ymd.getDay()))"
    }
    
    /// YYYY년 MM월 형식으로 반환해주는 계산 속성
    var yearmonth : String {
        "\(ymd.getYear())년 \(ymd.getMonth())월"
    }
    
    /// YYYY-MM 형식으로 반환해주는 계산 속성 (DB와의 조건 비교)
    var yearmonthComparison : String {
        return "\(ymd.getYear())-\(ymd.getMonth() < 10 ? "0" + String(ymd.getMonth()) : String(ymd.getMonth()))"
    }
    
    /// 1개월을 감소시키는 메소드
    mutating func decrease() {
        ymd.decrease()
    }
    
    /// 1개월을 증가시키는 메소드
    mutating func increase() {
        ymd.increase()
    }
    
    /// 날짜를 수정하는 메소드
    mutating func setDay(of day : Int) {
        ymd.setDay(of: day)
    }
    
    /// 개월을 수정하는 메소드
    mutating func setMonth(of month : Int) {
        ymd.setMonth(of: month)
    }
    
    /// 년도를 수정하는 메소드
    mutating func setYear(of year : Int) {
        ymd.setYear(of: year)
    }
}
