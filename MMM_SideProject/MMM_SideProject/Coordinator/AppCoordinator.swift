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
        let tabBarController = setTabBarController()
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let mainItem = UITabBarItem(title: "메인화면", image: UIImage(systemName: "trash"), tag: 0)
        let detailItem = UITabBarItem(title: "디테일화면", image: UIImage(systemName: "trash"), tag: 1)
        
        let mainCoornidator = MainCoordinator()
        mainCoornidator.parentCoordinator = self
        childCoordinators.append(mainCoornidator)
        let mainViewController = mainCoornidator.startPush()
        mainViewController.tabBarItem = mainItem
        
        let detailCoordinator = DetailCoordinator()
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        let detailViewController = detailCoordinator.startPush()
        detailViewController.tabBarItem = detailItem
        
        tabBarController.viewControllers = [mainViewController, detailViewController]
        
        return tabBarController
    }
    
    deinit {
        print("AppCoordinator 메모리 해제")
    }
}
