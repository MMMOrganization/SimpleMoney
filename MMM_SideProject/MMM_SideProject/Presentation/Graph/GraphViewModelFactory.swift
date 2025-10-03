//
//  GraphViewModelFactory.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

import Foundation

protocol GraphVMProducing {
    func createViewModel() -> GraphViewModel
}

final class GraphViewModelFactory: GraphVMProducing {
    private let repository: DataRepositoryInterface
    
    init(repository: DataRepositoryInterface) {
        self.repository = repository
    }
    
    func createViewModel() -> GraphViewModel {
        return GraphViewModel(repository: repository)
    }
}
