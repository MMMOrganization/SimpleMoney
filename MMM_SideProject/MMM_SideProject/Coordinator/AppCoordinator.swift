//
//  AppCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

final class AppCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushDetailVC() {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        
        detailCoordinator.start()
    }
    
    func start() {
        pushDetailVC()
    }
    
    deinit {
        print("AppCoordinator 메모리 해제")
    }
}

