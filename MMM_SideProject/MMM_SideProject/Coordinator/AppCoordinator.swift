//
//  AppCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

class AppCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    let window : UIWindow?
    var navigationController : UINavigationController
    
    init(_ window : UIWindow?, _ navigationController : UINavigationController) {
        self.window = window
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
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    deinit {
        print("AppCoordinator 메모리 해제")
    }
}
