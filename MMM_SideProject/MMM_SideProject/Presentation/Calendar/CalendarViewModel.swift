//
//  CalendarViewModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol CalendarViewModelDelegate : AnyObject {
    func popCalendarVC()
}

protocol CalendarViewModelInterface {
    var dismissButtonObserver : AnyObserver<Void> { get }
    var changeMonthObserver : AnyObserver<Date> { get }
    var decreaseObserver : AnyObserver<DateButtonType> { get }
    var increaseObserver : AnyObserver<DateButtonType> { get }
    
    var dateObservable : Observable<String> { get }
    var dateButtonTypeObservable : Observable<DateButtonType> { get }
}

class CalendarViewModel : CalendarViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    // MARK: - Observer (Subject)
    var dismissButtonSubject: PublishSubject<Void>
    var changeMonthSubject: PublishSubject<Date>
    var decreaseSubject: PublishSubject<DateButtonType>
    var increaseSubject: PublishSubject<DateButtonType>
    
    // MARK: - Observable (Subject)
    var dateSubject: BehaviorSubject<String>
    var dateButtonTypeSubject : PublishSubject<DateButtonType>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var changeMonthObserver: AnyObserver<Date>
    var decreaseObserver: AnyObserver<DateButtonType>
    var increaseObserver: AnyObserver<DateButtonType>
    
    // MARK: - Observable
    var dateObservable: Observable<String>
    var dateButtonTypeObservable: Observable<DateButtonType>
    
    weak var delegate : CalendarViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        changeMonthSubject = PublishSubject<Date>()
        decreaseSubject = PublishSubject<DateButtonType>()
        increaseSubject = PublishSubject<DateButtonType>()
        
        dateSubject = BehaviorSubject<String>(value: repository.readDate())
        dateButtonTypeSubject = PublishSubject<DateButtonType>()
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        changeMonthObserver = changeMonthSubject.asObserver()
        decreaseObserver = decreaseSubject.asObserver()
        increaseObserver = increaseSubject.asObserver()
        
        dateObservable = dateSubject
        dateButtonTypeObservable = dateButtonTypeSubject
        
        setCoordinator()
        setReactive()
    }
    
    func setCoordinator() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popCalendarVC()
        }.disposed(by: disposeBag)
    }
    
    func setReactive() {
        // TODO: - Date 계산, Observable 로 관찰 가능한 값으로 전달해야 함.
        // Page 바인딩을 해야 함.
        
        // MARK: - headerTitle UI 바인딩
        [decreaseSubject, increaseSubject].forEach { $0.subscribe { [weak self] dateButtonType in
            guard let dateButtonType = dateButtonType.element, let self = self else { return }
            repository.setDate(type: dateButtonType)
            dateSubject.onNext(repository.readDate())
            dateButtonTypeSubject.onNext(dateButtonType)
        }.disposed(by: disposeBag) }
    }
}
