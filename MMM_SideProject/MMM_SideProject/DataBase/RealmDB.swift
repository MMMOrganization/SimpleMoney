//
//  RealmDB.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/9/25.
//

import Foundation
import Realm
import RealmSwift

class RealmDTO : Object {
    @Persisted(primaryKey: true) var id : UUID
    @Persisted var date : Date
    @Persisted var type : 
}
