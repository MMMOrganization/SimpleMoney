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
    
    static func readExpendData() -> [CreateCellIcon] {
        return [CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend),
                CreateCellIcon(iconImage: UIImage(named: "DateImage2") ?? UIImage(), createType: .expend)]
    }
    
    static func readIncomeData() -> [CreateCellIcon] {
        return [CreateCellIcon(iconImage: UIImage(named: "circleGraph") ?? UIImage(), createType: .income),
                CreateCellIcon(iconImage: UIImage(named: "circleGraph") ?? UIImage(), createType: .income),
                CreateCellIcon(iconImage: UIImage(named: "circleGraph") ?? UIImage(), createType: .income),
                CreateCellIcon(iconImage: UIImage(named: "circleGraph") ?? UIImage(), createType: .income),
                CreateCellIcon(iconImage: UIImage(named: "circleGraph") ?? UIImage(), createType: .income)]
    }
}
