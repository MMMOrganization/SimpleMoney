//
//  Constants.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/11/24.
//

import UIKit
import RealmSwift
import Realm

public enum ColorConst {
    static let mainColorString = "4300D1"
    static let grayColorString = "767676"
    static let blackColorString = "111111"
}

public enum FontConst {
    static let mainFont = "Moneygraphy-Pixel"
}

public enum CreateType : String, PersistableEnum {
    case total
    case income
    case expend
}

public enum ButtonType : Int {
    case total = 0
    case income = 1
    case expend = 2
}

public enum DateButtonType {
    case increase
    case decrease
}
