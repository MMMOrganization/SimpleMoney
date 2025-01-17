//
//  RepositoryInterFace.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import Foundation

protocol DataRepositoryInterface {
    func readTotalData() -> [Entity]
}
