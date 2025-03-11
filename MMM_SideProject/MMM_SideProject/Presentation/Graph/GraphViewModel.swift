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

class GraphViewModel : GraphViewModelInterface {
    
    // MARK: - Subject (Observer)
    var dismissButtonSubject: PublishSubject<Void>
    var typeButtonDataSubject: PublishSubject<[(String, UIColor)]>
    var typeButtonTapSubject : BehaviorSubject<(String, UIColor)>
    var selectDateSubject : PublishSubject<String>
    
    // MARK: - Subject (Observable)
    var graphDataSubject: BehaviorSubject<[(String, Double)]>
    var entityDataSubject: PublishSubject<[Entity]>
    var dateSubject: BehaviorSubject<String>
    var dateListSubject : BehaviorSubject<[String]>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var typeButtonDataObserver: AnyObserver<[(String, UIColor)]>
    var typeButtonTapObserver: AnyObserver<(String, UIColor)>
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
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // TODO: - 지출타입의 데이터베이스를 다 긁어온다.
        // TODO: - 딕셔너리로 값을 받는다.
        // TODO: - 정리해서 그래프로 넘긴다.
        
        dismissButtonSubject = PublishSubject<Void>()
        typeButtonDataSubject = PublishSubject<[(String, UIColor)]>()
        typeButtonTapSubject = BehaviorSubject<(String, UIColor)>(value: ("", .mainColor))
        selectDateSubject = PublishSubject<String>()
        
        graphDataSubject = BehaviorSubject<[(String, Double)]>(value: repository.readGraphData())
        entityDataSubject = PublishSubject<[Entity]>()
        dateSubject = BehaviorSubject<String>(value: repository.readDate())
        dateListSubject = BehaviorSubject<[String]>(value: repository.readDateList())
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        typeButtonDataObserver = typeButtonDataSubject.asObserver()
        typeButtonTapObserver = typeButtonTapSubject.asObserver()
        selectDateObserver = selectDateSubject.asObserver()
        
        graphDataObservable = graphDataSubject
        typeButtonDataObservable = typeButtonDataSubject
        entityDataObservable = entityDataSubject
        dateObservable = dateSubject
        dateListObservable = dateListSubject
        
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
        
        selectDateSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] selectedDate in
                guard let self = self else { return }
                guard let dateStr = selectedDate.element else { return }
                dateSubject.onNext(dateStr)
                repository.setDate(dateStr: dateStr)
            }.disposed(by: disposeBag)
    }
}
