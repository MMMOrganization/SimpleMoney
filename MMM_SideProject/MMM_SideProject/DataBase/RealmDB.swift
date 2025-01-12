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
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var date : Date
    @Persisted var type : CreateType
    @Persisted var amount : Int
    @Persisted var iconImageURL : String?

    convenience init(type : CreateType, amount : Int) {
        self.init()
        self.type = type
        self.amount = amount
    }
}
