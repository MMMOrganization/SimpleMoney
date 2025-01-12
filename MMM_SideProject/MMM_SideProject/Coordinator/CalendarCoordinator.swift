//
//  CalendarCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import UIKit

class CalendarCoordinator : Coordinator, CalendarViewControllerDelegate {
    weak var parentCoordinator : Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let calendarViewController = CalendarViewController()
        calendarViewController.delegate = self
        
        self.navigationController.pushViewController(calendarViewController, animated: true)
    }
    
    func popCalendarVC() {
        parentCoordinator?.removeChild(self)
        
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("CalendarCoordinator 메모리 해제")
    }
}
