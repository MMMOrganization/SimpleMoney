//
//  DetailCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

// Flow가 이어지게끔 보이기 위해서 Graph, Calendar 의 화면 전환 로직을 담음.
class DetailCoordinator : Coordinator, DetailViewModelDelegate {
    
    weak var parentCoordinator : Coordinator?
    var childCoordinators : [Coordinator] = []
    var navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = MockDataRepository()
        let detailViewModel = DetailViewModel(repository: repository)
        detailViewModel.delegate = self
        
        let detailViewController = DetailViewController(viewModel : detailViewModel)
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func pushCalendarVC() {
        let calendarCoordinator = CalendarCoordinator(navigationController : navigationController)
        calendarCoordinator.parentCoordinator = self
        addChild(calendarCoordinator)
        
        calendarCoordinator.start()
    }
    
    func pushCreateVC() {
        let createCoordinator = CreateCoordinator(navigationController : navigationController)
        createCoordinator.parentCoordinator = self
        addChild(createCoordinator)
        
        createCoordinator.start()
    }
    
    func pushGraphVC() {
        let graphCoordinator = GraphCoordinator(navigationController: navigationController)
        graphCoordinator.parentCoordinator = self
        addChild(graphCoordinator)
        
        graphCoordinator.start()
    }
    
    func pushDeleteToastVC() {
        
    }
    
    deinit {
        print("DetailCoordinator 메모리 해제")
    }
}
