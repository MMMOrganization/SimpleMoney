//
//  Coordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import Foundation

protocol Coordinator {
    var childCoordinators : [Coordinator] { get set }
    
    func start()
}
