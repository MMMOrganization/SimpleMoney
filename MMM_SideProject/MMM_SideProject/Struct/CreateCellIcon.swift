//
//  CreateCellContainer.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 2/2/25.
//

import UIKit

struct CreateCellIcon {
    private let iconImageType : IconImageType
    private var isSelected : Bool = false
    
    init(iconImageType: IconImageType, isSelected : Bool = false) {
        self.iconImageType = iconImageType
        self.isSelected = isSelected
    }
    
    static func initReadData() -> [CreateCellIcon] {
        var dummyDataList = [
            CreateCellIcon(iconImageType: .date),
            CreateCellIcon(iconImageType: .bank),
            CreateCellIcon(iconImageType: .game),
            CreateCellIcon(iconImageType: .network),
            CreateCellIcon(iconImageType: .shopping),
                            ]
        
        dummyDataList[0].isSelected = true
        return dummyDataList
    }
    
    mutating func noneSelected() {
        isSelected = false
    }
    
    mutating func doneSelected() {
        isSelected = true
    }
    
    func getIsSelected() -> Bool {
        return isSelected
    }
    
    func getImageType() -> IconImageType {
        return iconImageType
    }
}
