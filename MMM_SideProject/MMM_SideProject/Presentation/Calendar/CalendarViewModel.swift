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
    var dayOfMonthClickObserver : AnyObserver<Int> { get }
    
    var dateObservable : Observable<String> { get }
    var dateButtonTypeObservable : Observable<DateButtonType> { get }
    var dataObservable : Observable<[Entity]> { get }
    var dailyAmountsObservable : Observable<[String:Int]> { get }
    
    func getAmountForDay(_ date : Date) -> Int?
}

class CalendarViewModel : CalendarViewModelInterface {
    
    var amountsDict : [String:Int] = .init()
    
    var disposeBag : DisposeBag = DisposeBag()
    
    // MARK: - Observer (Subject)
    var dismissButtonSubject: PublishSubject<Void>
    var changeMonthSubject: PublishSubject<Date>
    var decreaseSubject: PublishSubject<DateButtonType>
    var increaseSubject: PublishSubject<DateButtonType>
    var dayOfMonthClickSubject : PublishSubject<Int>
    
    // MARK: - Observable (Subject)
    var dateSubject: BehaviorSubject<String>
    var dateButtonTypeSubject : PublishSubject<DateButtonType>
    var dataSubject: BehaviorSubject<[Entity]>
    var dailyAmountsSubject : BehaviorSubject<[String:Int]>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var changeMonthObserver: AnyObserver<Date>
    var decreaseObserver: AnyObserver<DateButtonType>
    var increaseObserver: AnyObserver<DateButtonType>
    var dayOfMonthClickObserver: AnyObserver<Int>
    
    // MARK: - Observable
    var dateObservable: Observable<String>
    var dateButtonTypeObservable: Observable<DateButtonType>
    var dataObservable: Observable<[Entity]>
    var dailyAmountsObservable: Observable<[String:Int]>
    
    weak var delegate : CalendarViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        changeMonthSubject = PublishSubject<Date>()
        decreaseSubject = PublishSubject<DateButtonType>()
        increaseSubject = PublishSubject<DateButtonType>()
        dayOfMonthClickSubject = PublishSubject<Int>()
        
        dateSubject = BehaviorSubject<String>(value: repository.readDate())
        dateButtonTypeSubject = PublishSubject<DateButtonType>()
        dataSubject = BehaviorSubject<[Entity]>(value: repository.readDataOfDay())
        dailyAmountsSubject = BehaviorSubject<[String:Int]>(value: repository.readAmountsDict())
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        changeMonthObserver = changeMonthSubject.asObserver()
        decreaseObserver = decreaseSubject.asObserver()
        increaseObserver = increaseSubject.asObserver()
        dayOfMonthClickObserver = dayOfMonthClickSubject.asObserver()
        
        dateObservable = dateSubject
        dateButtonTypeObservable = dateButtonTypeSubject
        dataObservable = dataSubject
        dailyAmountsObservable = dailyAmountsSubject
        
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
            dailyAmountsSubject.onNext(repository.readAmountsDict())
        }.disposed(by: disposeBag) }
        
        // MARK: - Calendar Day Click 바인딩
        dayOfMonthClickSubject.subscribe { [weak self] dayInteger in
            guard let self = self, let dayInteger = dayInteger.element else { return }
            repository.setDay(of: dayInteger)
            dataSubject.onNext(repository.readDataOfDay())
        }.disposed(by: disposeBag)
        
        dailyAmountsSubject.subscribe { [weak self] amountsDict in
            guard let amountsDict = amountsDict.element, let self = self else {
                return
            }
            
            self.amountsDict = amountsDict
        }.disposed(by: disposeBag)
    }
    
    func getAmountForDay(_ date : Date) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        return amountsDict[dateString]
    }
}
