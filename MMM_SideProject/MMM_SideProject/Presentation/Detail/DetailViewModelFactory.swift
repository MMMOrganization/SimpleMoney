//
//  DetailViewModelFactory.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

import Foundation

protocol DetailVMProducing {
    func createViewModel() -> DetailViewModel
}

final class DetailViewModelFactory: DetailVMProducing {
    private let repository: DataRepositoryInterface
    
    init(repository: DataRepositoryInterface) {
        self.repository = repository
    }
    
    func createViewModel() -> DetailViewModel {
        return DetailViewModel(repository: repository)
    }
}
