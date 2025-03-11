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
    var typeButtonDataObserver : AnyObserver<[(String, UIColor)]> { get }
    var typeButtonTapObserver : AnyObserver<(String, UIColor)> { get }
    
    var graphDataObservable : Observable<[(String, Double)]> { get }
    var typeButtonDataObservable : Observable<[(String, UIColor)]> { get }
    var entityDataObservable : Observable<[Entity]> { get }
    var dateObservable : Observable<String> { get }
}

protocol GraphViewModelDelegate : AnyObject {
    func popGraphVC()
}

class GraphViewModel : GraphViewModelInterface {
    
    // MARK: - Subject (Observer)
    var dismissButtonSubject: PublishSubject<Void>
    var typeButtonDataSubject: PublishSubject<[(String, UIColor)]>
    var typeButtonTapSubject : BehaviorSubject<(String, UIColor)>
    
    // MARK: - Subject (Observable)
    var graphDataSubject: BehaviorSubject<[(String, Double)]>
    var entityDataSubject: PublishSubject<[Entity]>
    var dateSubject: BehaviorSubject<String>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var typeButtonDataObserver: AnyObserver<[(String, UIColor)]>
    var typeButtonTapObserver: AnyObserver<(String, UIColor)>
    
    // MARK: - Observable
    var graphDataObservable: Observable<[(String, Double)]>
    var typeButtonDataObservable : Observable<[(String, UIColor)]>
    var entityDataObservable: Observable<[Entity]>
    var dateObservable: Observable<String>
    
    weak var delegate : GraphViewModelDelegate?
    
    var disposeBag : DisposeBag = .init()
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // TODO: - 지출타입의 데이터베이스를 다 긁어온다.
        // TODO: - 딕셔너리로 값을 받는다.
        // TODO: - 정리해서 그래프로 넘긴다.
        
        dismissButtonSubject = PublishSubject<Void>()
        typeButtonDataSubject = PublishSubject<[(String, UIColor)]>()
        typeButtonTapSubject = BehaviorSubject<(String, UIColor)>(value: ("", .mainColor))
        
        // Date 포멧을 어떻게 할지 고민해봐야함.
        graphDataSubject = BehaviorSubject<[(String, Double)]>(value: repository.readGraphData())
        entityDataSubject = PublishSubject<[Entity]>()
        dateSubject = BehaviorSubject(value: repository.readDate())
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        typeButtonDataObserver = typeButtonDataSubject.asObserver()
        typeButtonTapObserver = typeButtonTapSubject.asObserver()
        
        graphDataObservable = graphDataSubject
        typeButtonDataObservable = typeButtonDataSubject
        entityDataObservable = entityDataSubject
        dateObservable = dateSubject
        
        setCoordinator()
        setReactive()
    }
    
    func setCoordinator() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popGraphVC()
        }.disposed(by: disposeBag)
    }
    
    func setReactive() {
        // TODO: - 날짜의 변경을 감지하고 graphDataSubject에 스트림을 보내야 함.
        typeButtonTapSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] typeItem in
                guard let self = self, let typeItem = typeItem.element else {
                    return
                }
                
                entityDataSubject.onNext(repository.readData(typeName: typeItem.0, color: typeItem.1))
            }.disposed(by: disposeBag)
    }
}
