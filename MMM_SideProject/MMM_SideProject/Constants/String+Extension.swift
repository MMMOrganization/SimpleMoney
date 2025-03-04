//
//  String+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/3/25.
//

import Foundation

extension String {
    // MARK: - String 중에서 숫자만 남기는 함수
    var toAmount : Int {
        var tempString : String = ""
        for alpha in self {
            guard Int(String(alpha)) != nil else { continue }
            tempString += String(alpha)
        }
        
        return Int(tempString) ?? 0
    }
}
