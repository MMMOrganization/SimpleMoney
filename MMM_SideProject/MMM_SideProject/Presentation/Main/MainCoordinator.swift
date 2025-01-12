//
//  MainCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

class MainCoordinator : Coordinator {
    weak var parentCoordinator : Coordinator?
    var childCoordinators : [Coordinator] = []
    var navigationController : UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
    // MainVC 객체를 생성하여 반환함.
    func startPush() -> UINavigationController {
        let mainViewController : UIViewController = MainViewController()
        mainViewController.view.backgroundColor = .white
        navigationController.setViewControllers([mainViewController], animated: true)
        
        return navigationController
    }
    
    deinit {
        print("MainCoordinator 메모리 해제")
    }
}
