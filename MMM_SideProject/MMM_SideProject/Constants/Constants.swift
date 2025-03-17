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
    static let mainFont = "Moneygraphy-Rounded"
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

public enum DateButtonType : Int {
    case increase = 1
    case decrease = -1
}

public enum GraphType : Int {
    case bar
    case circle
}

public enum DetailCellStyle {
    case compact // 간격 X
    case spacious // 간격 O
}

public enum IconImageType : String, PersistableEnum {
    case date
    case bank
    case game
    case network
    case shopping
    
    var getImage : UIImage {
        switch self {
        case .date:
            return UIImage(named: "dateImage") ?? UIImage()
        case .bank:
            return UIImage(named: "bankImage") ?? UIImage()
        case .game:
            return UIImage(named: "gameImage") ?? UIImage()
        case .network:
            return UIImage(named: "networkImage") ?? UIImage()
        case .shopping:
            return UIImage(named: "shoppingImage") ?? UIImage()
        }
    }
}
