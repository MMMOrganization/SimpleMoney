//
//  RepositoryInterFace.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import Foundation

protocol DataRepositoryInterface {
    func readData() -> [Entity]
    func readDate() -> String
    
    func setDate(type : DateButtonType)
    func setState(type : ButtonType)
}
