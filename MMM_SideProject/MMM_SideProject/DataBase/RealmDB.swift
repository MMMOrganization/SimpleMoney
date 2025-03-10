//
//  RealmDB.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/9/25.
//

import Foundation
import Realm
import RealmSwift

class UserDB : Object {
    @Persisted(primaryKey: true) var id : UUID = UUID()
    @Persisted var createType : CreateType
    @Persisted var moneyAmount : Int
    @Persisted var iconImageType : IconImageType
    @Persisted var typeString : String
    @Persisted var dateString : String

    convenience init(createType: CreateType, moneyAmount: Int, iconImageType: IconImageType, typeString: String, dateString: String) {
        self.init()
        self.createType = createType
        self.moneyAmount = moneyAmount
        self.iconImageType = iconImageType
        self.typeString = typeString
        self.dateString = dateString
    }
}
