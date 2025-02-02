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
    
    init(_ window : UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navigationController = setNavigationController()
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setNavigationController() -> UINavigationController {
        let detailCoordinator = DetailCoordinator()
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        let detailViewController = detailCoordinator.startPush()
        
        return detailViewController
    }
    
    deinit {
        print("AppCoordinator 메모리 해제")
    }
}
