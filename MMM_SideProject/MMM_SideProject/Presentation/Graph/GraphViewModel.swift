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
    var expendTypeObserver : AnyObserver<ExpendType> { get }
    
    var dataObservable : Observable<[Entity]> { get }
}

protocol GraphViewModelDelegate : AnyObject {
    func popGraphVC()
}

class GraphViewModel : GraphViewModelInterface {
    
    var dismissButtonSubject: PublishSubject<Void>
    var expendTypeSubject: PublishSubject<ExpendType>
    
    var dataSubject : BehaviorSubject<[Entity]>
    
    var dismissButtonObserver: AnyObserver<Void>
    var expendTypeObserver: AnyObserver<ExpendType>
    
    var dataObservable: Observable<[Entity]>
    
    weak var delegate : GraphViewModelDelegate?
    
    var disposeBag : DisposeBag = .init()
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        expendTypeSubject = PublishSubject<ExpendType>()
        
        dataSubject = BehaviorSubject<[Entity]>(value: repository.readData())
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        expendTypeObserver = expendTypeSubject.asObserver()
        
        dataObservable = dataSubject
        
        setCoordinator()
        setReactive()
    }
    
    func setCoordinator() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popGraphVC()
        }.disposed(by: disposeBag)
    }
    
    func setReactive() {
        // MARK: - expendTypeObserver 가 받으면 어떤 Cell을 반환해야 할지 생각하고 Cell을 전달해야 함.
        expendTypeSubject.subscribe { [weak self] expendType in
            guard let self = self, let expendType = expendType.element else { return }
            // MARK: - ExpendType 만 가져오는 Entity 를 DataRepository에서 만들어야 함.
            dataSubject.onNext(self.repository.readDataForExpendType(of: expendType))
        }.disposed(by: disposeBag)
    }
}
