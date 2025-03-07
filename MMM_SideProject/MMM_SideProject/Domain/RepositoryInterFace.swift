//
//  RepositoryInterFace.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import Foundation
import UIKit

// MARK: - 상태 관리, 데이터의 저장 조회 및 간단한 데이터의 변환 레이어
protocol DataRepositoryInterface {
    func readData() -> [Entity]
    func readData(typeName : String, color : UIColor) -> [Entity]
    func readDate() -> String
    func readDataOfDay() -> [Entity]
    func readGraphData() -> [(String, Double)]
    func readAmountsDict() -> [String : Int]
    func readDataForCreateCell(of type : CreateType, selectedIndex : Int) -> [CreateCellIcon]
    
    func setDate(type : DateButtonType)
    func setState(type : ButtonType)
    
    func setDay(of day : Int)
}
