//
//  CreateError.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/3/25.
//

import Foundation

enum CreateError : Error {
    case zeroInputMoney
    case noneSetDate
    case dataBaseError
    
    var description : String {
        switch self {
        case .zeroInputMoney:
            return "금액을 입력해주세요."
        case .noneSetDate:
            return "날짜를 선택해주세요."
        case .dataBaseError:
            return "데이터베이스 에러 발생했습니다."
        }
    }
}
