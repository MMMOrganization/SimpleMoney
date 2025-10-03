//
//  GraphCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit

final class GraphCoordinator : Coordinator, GraphViewModelDelegate {
    weak var parentCoordinator : Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var viewModelFactory: GraphVMProducing
    
    init(navigationController : UINavigationController, viewModelFactory: GraphVMProducing) {
        self.navigationController = navigationController
        self.viewModelFactory = viewModelFactory
    }
    
    func start() {
        let viewModel = viewModelFactory.createViewModel()
        viewModel.delegate = self
        let graphViewController = GraphViewController(viewModel: viewModel)
        navigationController.pushViewController(graphViewController, animated: true)
    }
    
    func popGraphVC() {
        parentCoordinator?.removeChild(self)
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("GraphCoordinator 메모리 해제")
    }
}



