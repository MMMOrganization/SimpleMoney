//
//  String+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/3/25.
//

import Foundation

extension String {
    // MARK: - String 중에서 숫자만 남기는 함수
    func toAmount(with createType : CreateType) -> Int {
        var tempString : String = ""
        for alpha in self {
            guard Int(String(alpha)) != nil else { continue }
            tempString += String(alpha)
        }
        
        guard let tempValue = Int(tempString) else {
            print("String Extension - toAmount Error")
            return 0
        }
        
        return createType == .expend ? -tempValue : tempValue
    }
}
