//
//  CreateCellContainer.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 2/2/25.
//

import UIKit

struct CreateCellIcon {
    let iconImage : UIImage
    let createType : CreateType
    var isSelected : Bool
    
    init(iconImage: UIImage, createType: CreateType, isSelected : Bool = false) {
        self.iconImage = iconImage
        self.createType = createType
        self.isSelected = isSelected
    }
    
    static func readExpendData(at index : Int) -> [CreateCellIcon] {
        var dummyDataList = [
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType:.expend)
                            ]
        
        dummyDataList[index] =
        CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend, isSelected: true)
        
        return dummyDataList
    }
    
    static func readIncomeData(at index : Int) -> [CreateCellIcon] {
        var dummyDataList = [
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income),
                            CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .income)
                            ]
        
        dummyDataList[index] =
        CreateCellIcon(iconImage: UIImage(named: "dateImage") ?? UIImage(), createType: .expend, isSelected: true)
        
        return dummyDataList
    }
    
    static func readIconImage(at index : Int) -> UIImage {
        return UIImage(named : "dateImage") ?? UIImage()
    }
}
