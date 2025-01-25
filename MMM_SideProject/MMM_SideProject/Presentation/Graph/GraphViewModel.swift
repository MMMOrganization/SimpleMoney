//
//  GraphViewModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol GraphViewModelInterface {
    var dismissButtonObserver : AnyObserver<Void> { get }
}

protocol GraphViewModelDelegate : AnyObject {
    func popGraphVC()
}

class GraphViewModel : GraphViewModelInterface {
    
    var dismissButtonSubject: PublishSubject<Void>
    
    var dismissButtonObserver: AnyObserver<Void>
    
    weak var delegate : GraphViewModelDelegate?
    
    var disposeBag : DisposeBag = .init()
    
    var repository : GraphRepositoryInterface
    var graphStyle : GraphType
    
    init(repository : GraphRepositoryInterface, graphStyle : GraphType) {
        self.repository = repository
        self.graphStyle = graphStyle
        
        dismissButtonSubject = PublishSubject<Void>()
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        
        setCoordinator()
    }
    
    func setCoordinator() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popGraphVC()
        }.disposed(by: disposeBag)
    }
}
