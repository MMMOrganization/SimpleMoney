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
    
    var graphDataObservable : Observable<[String : Double]> { get }
}

protocol GraphViewModelDelegate : AnyObject {
    func popGraphVC()
}

class GraphViewModel : GraphViewModelInterface {
    
    var dismissButtonSubject: PublishSubject<Void>
    
    var graphDataSubject: BehaviorSubject<[String : Double]>
    
    var dismissButtonObserver: AnyObserver<Void>
    
    var graphDataObservable: Observable<[String : Double]>
    
    weak var delegate : GraphViewModelDelegate?
    
    var disposeBag : DisposeBag = .init()
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // TODO: - 지출타입의 데이터베이스를 다 긁어온다.
        // TODO: - 딕셔너리로 값을 받는다.
        // TODO: - 정리해서 그래프로 넘긴다.
        
        dismissButtonSubject = PublishSubject<Void>()
        
        // Date 포멧을 어떻게 할지 고민해봐야함.
        graphDataSubject = BehaviorSubject<[String : Double]>(value: repository.readGraphData(date: "2025년03월"))
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        
        graphDataObservable = graphDataSubject
        
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
    }
}
