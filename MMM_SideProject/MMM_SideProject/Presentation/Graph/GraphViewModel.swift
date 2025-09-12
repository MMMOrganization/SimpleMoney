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
    var typeButtonTapObserver : AnyObserver<String> { get }
    var selectDateObserver : AnyObserver<String> { get }
    
    var graphDataObservable : Observable<[(String, Double)]> { get }
    var typeButtonDataObservable : Observable<[(String, UIColor)]> { get }
    var entityDataObservable : Observable<[Entity]> { get }
    var dateObservable : Observable<String> { get }
    var dateListObservable : Observable<[String]> { get }
}

protocol GraphViewModelDelegate : AnyObject {
    func popGraphVC()
}

final class GraphViewModel : GraphViewModelInterface {
    
    // MARK: - Subject (Observer)
    var dismissButtonSubject: PublishSubject<Void>
    var typeButtonDataSubject: PublishSubject<[(String, UIColor)]>
    var typeButtonTapSubject : PublishSubject<String>
    var selectDateSubject : PublishSubject<String>
    
    // MARK: - Subject (Observable)
    var graphDataSubject: BehaviorSubject<[(String, Double)]>
    var entityDataSubject: BehaviorSubject<[Entity]>
    var dateSubject: BehaviorSubject<String>
    var dateListSubject : BehaviorSubject<[String]>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var typeButtonDataObserver: AnyObserver<[(String, UIColor)]>
    var typeButtonTapObserver: AnyObserver<String>
    var selectDateObserver: AnyObserver<String>
    
    // MARK: - Observable
    var graphDataObservable: Observable<[(String, Double)]>
    var typeButtonDataObservable : Observable<[(String, UIColor)]>
    var entityDataObservable: Observable<[Entity]>
    var dateObservable: Observable<String>
    var dateListObservable: Observable<[String]>
    
    weak var delegate : GraphViewModelDelegate?
    
    var disposeBag : DisposeBag = .init()
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface = DataRepository()) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        typeButtonDataSubject = PublishSubject<[(String, UIColor)]>()
        typeButtonTapSubject = PublishSubject<String>()
        selectDateSubject = PublishSubject<String>()
        
        graphDataSubject = BehaviorSubject<[(String, Double)]>(value: repository.readGraphData())
        entityDataSubject = BehaviorSubject<[Entity]>(value: repository.readData(typeName: ""))
        dateSubject = BehaviorSubject<String>(value: repository.readDate())
        dateListSubject = BehaviorSubject<[String]>(value: repository.readDateList())
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        typeButtonDataObserver = typeButtonDataSubject.asObserver()
        typeButtonTapObserver = typeButtonTapSubject.asObserver()
        selectDateObserver = selectDateSubject.asObserver()
        
        graphDataObservable = graphDataSubject
        typeButtonDataObservable = typeButtonDataSubject
        entityDataObservable = entityDataSubject.asObservable()
        dateObservable = dateSubject
        dateListObservable = dateListSubject
        
        setCoordinator()
        setReactive()
    }
    
    func setCoordinator() {
        dismissButtonSubject.subscribe(with: self) { owner, _ in
            owner.delegate?.popGraphVC()
        }.disposed(by: disposeBag)
    }
    
    func setReactive() {
        typeButtonTapSubject
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, typeItem in
                owner.entityDataSubject.onNext(owner.repository.readData(typeName: typeItem))
            }.disposed(by: disposeBag)
        
        selectDateSubject
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, dateStr in
                owner.dateSubject.onNext(dateStr)
                owner.repository.setDate(dateStr: dateStr)
                owner.graphDataSubject.onNext(owner.repository.readGraphData())
                owner.entityDataSubject.onNext(owner.repository.readData(typeName: ""))
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print("GraphViewModel - 메모리 해제")
    }
}
