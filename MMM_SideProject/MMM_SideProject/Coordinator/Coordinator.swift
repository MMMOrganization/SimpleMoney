//
//  Coordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import Foundation

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func addChild(_ coordinator : Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator : Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}                                                                         
