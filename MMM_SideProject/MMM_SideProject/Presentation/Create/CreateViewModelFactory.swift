//
//  CreateViewModelFactory.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

import Foundation

protocol CreateVMProducing {
    func createViewModel() -> CreateViewModel
}

final class CreateViewModelFactory: CreateVMProducing {
    private let repository: DataRepositoryInterface
    
    init(repository: DataRepositoryInterface) {
        self.repository = repository
    }
    
    func createViewModel() -> CreateViewModel {
        return CreateViewModel(repository: repository)
    }
}
