//
//  DetailCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

class DetailCoordinator : Coordinator {
    var parentCoordinator : Coordinator?
    var childCoordinators : [Coordinator] = []
    var navigationController : UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
    // MainVC 객체를 생성하여 반환함.
    func startPush() -> UINavigationController {
        let detailViewController : UIViewController = DetailViewController()
        detailViewController.view.backgroundColor = .white
        navigationController.setViewControllers([detailViewController], animated: true)
        
        return navigationController
    }
}
