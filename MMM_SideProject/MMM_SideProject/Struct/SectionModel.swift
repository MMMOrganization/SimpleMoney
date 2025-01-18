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
}

extension SectionModel: SectionModelType {
    typealias Item = Entity // 실제 아이템 타입으로 교체
    
    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
