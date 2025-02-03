//
//  DetailCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/11/25.
//

import UIKit

class DetailCoordinator : Coordinator, DetailViewModelDelegate {
    
    weak var parentCoordinator : Coordinator?
    var childCoordinators : [Coordinator] = []
    var navigationController : UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {}
    
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
    
    func pushGraphVC(graphType: GraphType) {
        let graphCoordinator = GraphCoordinator(navigationController: navigationController)
        graphCoordinator.parentCoordinator = self
        addChild(graphCoordinator)
        
        graphCoordinator.start()
    }
    
    // MainVC 객체를 생성하여 반환함.
    func startPush() -> UINavigationController {
        let repository = MockDataRepository()
        let detailViewModel = DetailViewModel(repository: repository)
        detailViewModel.delegate = self
        
        let detailViewController = DetailViewController(viewModel : detailViewModel)
        detailViewController.view.backgroundColor = .white
        navigationController.setViewControllers([detailViewController], animated: true)
        
        return navigationController
    }
    
    deinit {
        print("DetailCoordinator 메모리 해제")
    }
}
