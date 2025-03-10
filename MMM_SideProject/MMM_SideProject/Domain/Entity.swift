//
//  Entity.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/14/25.
//

import UIKit
import RxDataSources

// MARK: 뷰에 표시될 데이터 구조체의 역할
// TODO: - Entity에 지출 타입 프로퍼티를 생성해야 함.
struct Entity {
    let id : UUID
    let dateStr : String
    let typeStr : String
    let createType : CreateType
    let amount : Int
    let iconImage : UIImage
    
    
    var color : UIColor = .clear
    
    init(id: UUID, dateStr: String, typeStr : String, createType: CreateType, amount: Int, iconImage: UIImage, color: UIColor = .clear) {
        self.id = id
        self.dateStr = dateStr
        self.typeStr = typeStr
        self.createType = createType
        self.amount = amount
        self.iconImage = iconImage
        self.color = color
    }
}

// MARK: - Animatable 한 TableView를 위한 필수 채택 프로토콜
extension Entity: IdentifiableType, Equatable {
    // MARK: - Section Identifier (고유 식별자)
    public var identity: UUID {
        return id
    }
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id == rhs.id
    }
}
