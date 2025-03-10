//
//  SectionModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/18/25.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [Item]
    
    var identity : String {
        return header
    }
}

extension SectionModel: AnimatableSectionModelType {
    typealias Item = Entity // 실제 아이템 타입으로 교체
    typealias Identity = String
    
    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SingleSectionModel {
    var items: [Item]
}

extension SingleSectionModel : AnimatableSectionModelType {
    typealias Item = Entity
    typealias Identity = String
    
    var identity : String {
        return ""
    }
    
    init(original: SingleSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
