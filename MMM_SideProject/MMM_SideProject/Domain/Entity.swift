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
    
    // MARK: - 지출 항목에 해당했을 때만 존재함.
    var expendType : ExpendType?
    
    init(id: UUID, dateStr: String, createType: CreateType, amount: Int, iconImage: UIImage, expendType: ExpendType? = nil) {
        self.id = id
        self.dateStr = dateStr
        self.createType = createType
        self.amount = amount
        self.iconImage = iconImage
        self.expendType = expendType
    }
}

extension Entity {
    
}
