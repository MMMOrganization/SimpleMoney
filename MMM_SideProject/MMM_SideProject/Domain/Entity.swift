//
//  Entity.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/14/25.
//

import UIKit

// MARK: 뷰에 표시될 데이터 구조체의 역할
// TODO: - Entity에 지출 타입 프로퍼티를 생성해야 함.
struct Entity {
    let id : UUID
    let dateStr : String
    let createType : CreateType
    let amount : Int
    let iconImage : UIImage
}

extension Entity {
    
}
