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
    var stringDateObserver : AnyObserver<String> { get }
    var stringTypeObserver : AnyObserver<String> { get }
    var inputMoneyObserver : AnyObserver<String> { get }
    
    var dataObservable : Observable<[CreateCellIcon]> { get }
    var stringDateObservable : Observable<String> { get }
    var stringTypeObservable : Observable<String> { get }
    var inputMoneyObservable : Observable<String> { get }
}

protocol CreateViewModelDelegate : AnyObject {
    func popCreateVC()
}

class CreateViewModel : CreateViewModelInterface {
    
    // TODO: - ViewModel에서 Create로 만들어진 구조체가 있어야 함.
    // TODO: - 구조체를 통해서 Realm 에 Create를 진행해야 함.
    // Date, typeLabel, inputMoney, Icon 총 4개의 검증이 필요
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var dismissButtonSubject: PublishSubject<Void>
    var createTypeSubject : BehaviorSubject<CreateType>
    var stringDateSubject : PublishSubject<String>
    var stringTypeSubject : BehaviorSubject<String>
    var inputMoneySubject : BehaviorSubject<String>
    
    var dataSubject : BehaviorSubject<[CreateCellIcon]>
    
    var dismissButtonObserver: AnyObserver<Void>
    var createTypeObserver: AnyObserver<CreateType>
    var stringDateObserver: AnyObserver<String>
    var stringTypeObserver: AnyObserver<String>
    var inputMoneyObserver: AnyObserver<String>
    
    var dataObservable: Observable<[CreateCellIcon]>
    var stringDateObservable: Observable<String>
    //var stringTypeObservable: Observable<String>

    // MARK: - Lazy Observable (다른 Observable에 스트림이 이어진 관계)
    lazy var inputMoneyObservable : Observable<String> = inputMoneySubject
        .map {
            if $0 == "" { return "0원" }
            guard let intValue = Int($0) else { return "" }
            return intValue.toCurrency
        }
    
    lazy var stringTypeObservable : Observable<String> = stringTypeSubject
        .map {
            if $0 == "" { return "기타" }
            return $0
        }
    
    weak var delegate : CreateViewModelDelegate?
    
    var createType : CreateType = .expend
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        createTypeSubject = BehaviorSubject<CreateType>(value: .expend)
        stringDateSubject = PublishSubject<String>()
        stringTypeSubject = BehaviorSubject<String>(value: "기타")
        inputMoneySubject = BehaviorSubject<String>(value: "")
        
        dataSubject = BehaviorSubject<[CreateCellIcon]>(value: repository.readDataForCreateCell(of: createType))
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        createTypeObserver = createTypeSubject.asObserver()
        stringDateObserver = stringDateSubject.asObserver()
        stringTypeObserver = stringTypeSubject.asObserver()
        inputMoneyObserver = inputMoneySubject.asObserver()
        
        dataObservable = dataSubject
        stringDateObservable = stringDateSubject
        
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
