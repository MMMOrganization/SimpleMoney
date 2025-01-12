//
//  CreateViewModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol CreateViewModelInterface {
    var dismissButtonObserver : AnyObserver<Void> { get }
}

protocol CreateViewModelDelegate : AnyObject {
    func popCreateVC()
}

class CreateViewModel : CreateViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var dismissButtonSubject: PublishSubject<Void>
    
    var dismissButtonObserver: AnyObserver<Void>
    
    weak var delegate : CreateViewModelDelegate?
    
    init() {
        dismissButtonSubject = PublishSubject<Void>()
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        
        setReactive()
    }
    
    func setReactive() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popCreateVC()
        }.disposed(by: disposeBag)
    }
}
