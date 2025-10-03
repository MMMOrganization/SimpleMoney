//
//  CreateCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import UIKit

final class CreateCoordinator : Coordinator, CreateViewModelDelegate {
    weak var parentCoordinator : Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController : UINavigationController
    var viewModelFactory: CreateVMProducing
    
    init(navigationController : UINavigationController, viewModelFactory: CreateVMProducing) {
        self.navigationController = navigationController
        self.viewModelFactory = viewModelFactory
    }
    
    func start() {
        let viewModel = viewModelFactory.createViewModel()
        viewModel.delegate = self
        
        let createViewController = CreateViewController(viewModel: viewModel)
        navigationController.pushViewController(createViewController, animated: true)
    }
    
    func popCreateVC() {
        parentCoordinator?.removeChild(self)
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("CreateCoordinator 메모리 해제")
    }
}
