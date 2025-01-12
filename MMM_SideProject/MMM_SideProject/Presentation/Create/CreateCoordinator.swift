//
//  CreateCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import UIKit

class CreateCoordinator : Coordinator, CreateViewModelDelegate {
    weak var parentCoordinator : Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let createViewModel = CreateViewModel()
        createViewModel.delegate = self
        
        let createViewController = CreateViewController(viewModel: createViewModel)
        self.navigationController.pushViewController(createViewController, animated: true)
    }
    
    func popCreateVC() {
        // 강한 참조로 계속해서 갖고있기 때문에, 화면이 사라지더라도 계속 CreateCoordinator 객체가 유지됨.
        // 그렇기 때문에 없애줘서 참조를 해제해 줘야 함.
        parentCoordinator?.removeChild(self)
        
        self.navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("CreateCoordinator 메모리 해제")
    }
}
