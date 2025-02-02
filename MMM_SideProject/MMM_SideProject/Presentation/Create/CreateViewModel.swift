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
    var createTypeObserver : AnyObserver<CreateType> { get }
    
    var dataObservable : Observable<[CreateCellIcon]> { get }
}

protocol CreateViewModelDelegate : AnyObject {
    func popCreateVC()
}

class CreateViewModel : CreateViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var dismissButtonSubject: PublishSubject<Void>
    var createTypeSubject : BehaviorSubject<CreateType>
    
    var dataSubject : BehaviorSubject<[CreateCellIcon]>
    
    var dismissButtonObserver: AnyObserver<Void>
    var createTypeObserver: AnyObserver<CreateType>
    
    var dataObservable: Observable<[CreateCellIcon]>
    
    weak var delegate : CreateViewModelDelegate?
    
    var createType : CreateType = .expend
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        createTypeSubject = BehaviorSubject<CreateType>(value: .expend)
        
        dataSubject = BehaviorSubject<[CreateCellIcon]>(value: repository.readDataForCreateCell(of: createType))
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        createTypeObserver = createTypeSubject.asObserver()
        
        dataObservable = dataSubject
        
        setReactive()
    }
    
    func setReactive() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popCreateVC()
        }.disposed(by: disposeBag)
        
        // MARK: - CreateCell Icon 과 지출, 수입 버튼의 바인딩
        createTypeSubject.subscribe { [weak self] createType in
            guard let self = self, let createType = createType.element else { return }
            self.createType = createType
            // TODO: - CollectionView의 데이터가 변경되어야 함.
            dataSubject.onNext(repository.readDataForCreateCell(of: createType))
        }.disposed(by: disposeBag)
    }
}
