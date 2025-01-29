//
//  GraphCoordinator.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit

class GraphCoordinator : Coordinator, GraphViewModelDelegate {
    
    weak var parentCoordinator : Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController : UINavigationController
    var graphStyle : GraphType
    
    init(navigationController : UINavigationController, graphStyle : GraphType) {
        self.navigationController = navigationController
        self.graphStyle = graphStyle
    }
    
    func start() {
        // TODO: - graphStyle 에 따라서 표현하는 View가 달라짐.
        let graphRepository = MockGraphRepository()
        let dataRepository = MockDataRepository()
        let viewModel = GraphViewModel(repository: graphRepository, graphStyle: graphStyle)
        let graphViewModel = GraphViewModelForSwiftUI(repository: dataRepository)
        viewModel.delegate = self
        
        let graphViewController = GraphViewController(viewModel: viewModel, graphViewModel: graphViewModel)
        self.navigationController.pushViewController(graphViewController, animated: true)
    }
    
    func popGraphVC() {
        parentCoordinator?.removeChild(self)
        self.navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("GraphCoordinator 메모리 해제")
    }
}
