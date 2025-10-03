//
//  CalendarViewModelFactory.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

import Foundation

protocol CalendarVMProducing {
    func createViewModel() -> CalendarViewModel
}

final class CalendarViewModelFactory: CalendarVMProducing {
    private let repository: DataRepositoryInterface
    
    init(repository: DataRepositoryInterface) {
        self.repository = repository
    }
    
    func createViewModel() -> CalendarViewModel {
        return CalendarViewModel(repository: repository)
    }
}
