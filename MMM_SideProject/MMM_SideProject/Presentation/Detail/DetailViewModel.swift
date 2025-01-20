//
//  DetailViewModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailViewModelInterface {
    var dateButtonObserver : AnyObserver<Void> { get }
    var plusButtonObserver : AnyObserver<Void> { get }
    var totalDataObserver : AnyObserver<ButtonType> { get }
    var incomeDataObserver : AnyObserver<ButtonType> { get }
    var expendDataObserver : AnyObserver<ButtonType> { get }
    var dateIncreaseButtonObserver : AnyObserver<DateButtonType> { get }
    var dateDecreaseButtonObserver : AnyObserver<DateButtonType> { get }
    
    var sectionModelObservable : Observable<[SectionModel]> { get }
    var selectedButtonIndexObservable : Observable<Int> { get }
    var dateObservable : Observable<String> { get }
    var monthObservable : Observable<String> { get }
    var totalAmountObservable : Observable<String> { get }
}

protocol DetailViewModelDelegate : AnyObject {
    func pushCalendarVC()
    func pushCreateVC()
}

class DetailViewModel : DetailViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    // MARK: - Observer (Subject)
    var dateButtonSubject : PublishSubject<Void>
    var plusButtonSubject : PublishSubject<Void>
    var totalDataSubject : BehaviorSubject<ButtonType>
    var incomeDataSubject : PublishSubject<ButtonType>
    var expendDataSubject : PublishSubject<ButtonType>
    var dateIncreaseButtonSubject : PublishSubject<DateButtonType>
    var dateDecreaseButtonSubject : PublishSubject<DateButtonType>
    
    
    // MARK: - Observable (Subject)
    var selectedButtonIndexSubject : PublishSubject<Int>
    var dateSubject : PublishSubject<String>
    var entitySubject : BehaviorSubject<[Entity]> = BehaviorSubject<[Entity]>(value: [])
    var sectionModelSubject : BehaviorSubject<[SectionModel]> = BehaviorSubject<[SectionModel]>(value: [])
    
    // MARK: - Observer
    var dateButtonObserver: AnyObserver<Void>
    var plusButtonObserver: AnyObserver<Void>
    var totalDataObserver: AnyObserver<ButtonType>
    var incomeDataObserver: AnyObserver<ButtonType>
    var expendDataObserver: AnyObserver<ButtonType>
    var dateIncreaseButtonObserver: AnyObserver<DateButtonType>
    var dateDecreaseButtonObserver: AnyObserver<DateButtonType>
    
    
    // MARK: - Observable
    var entityObservable: Observable<[Entity]>
    var selectedButtonIndexObservable: Observable<Int>
    var dateObservable: Observable<String>
    
    // MARK: - Lazy Observable (다른 Observable에 스트림이 이어진 관계)
    lazy var monthObservable: Observable<String> = dateObservable
        .map { String($0.split(separator: "년 ")[1] + " 통계") }
    
    lazy var sectionModelObservable: Observable<[SectionModel]> = entityObservable.map {
        var tempDictionary = [String : [Entity]]()
        $0.forEach { entity in
            if (tempDictionary[entity.dateStr] == nil) { tempDictionary[entity.dateStr] = [entity] }
            else { tempDictionary[entity.dateStr]?.append(entity) }
        }
        return tempDictionary.map {
            SectionModel(header: $0.key, items: $0.value)
        }
    }
    
    lazy var totalAmountObservable: Observable<String> = entityObservable.map {
        $0.map { $0.amount }.reduce(0, +).toCurrency
    }
    
    // MARK: - Delegate 및 Initializer
    weak var delegate : DetailViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // MARK: - Observer (Subject)
        dateButtonSubject = PublishSubject<Void>()
        plusButtonSubject = PublishSubject<Void>()
        totalDataSubject = BehaviorSubject<ButtonType>(value: .total)
        incomeDataSubject = PublishSubject<ButtonType>()
        expendDataSubject = PublishSubject<ButtonType>()
        dateDecreaseButtonSubject = PublishSubject<DateButtonType>()
        dateIncreaseButtonSubject = PublishSubject<DateButtonType>()
        
        // MARK: - Observable (Subject)
        selectedButtonIndexSubject = PublishSubject<Int>()
        dateSubject = PublishSubject<String>()
        
        // MARK: - Observer
        dateButtonObserver = dateButtonSubject.asObserver()
        plusButtonObserver = plusButtonSubject.asObserver()
        totalDataObserver = totalDataSubject.asObserver()
        incomeDataObserver = incomeDataSubject.asObserver()
        expendDataObserver = expendDataSubject.asObserver()
        dateDecreaseButtonObserver = dateDecreaseButtonSubject.asObserver()
        dateIncreaseButtonObserver = dateIncreaseButtonSubject.asObserver()
        
        // MARK: - Observable
        selectedButtonIndexObservable = selectedButtonIndexSubject
        dateObservable = dateSubject
        entityObservable = entitySubject
        
        setCoordinator()
        setBind()
    }
    
    func setCoordinator() {
        dateButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.pushCalendarVC()
        }.disposed(by: disposeBag)
        
        plusButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.pushCreateVC()
        }.disposed(by: disposeBag)
    }
    
    func setBind() {
        // MARK: - showButton <-> Data 바인딩
        
        // 구독이 될 때 즉시 초기값을 던져주는 BehaivorSubject를 사용해서 처음에 total을 보여주도록 설정.
        [totalDataSubject, incomeDataSubject, expendDataSubject].forEach { $0.subscribe { [weak self] selectedButton in
            guard let self = self, let selectedButtonType = selectedButton.element else { return }
            repository.setState(type: selectedButtonType)
            entitySubject.onNext(repository.readData())
        }.disposed(by: disposeBag) }
        
        // MARK: - showButton <-> Color 바인딩
        [totalDataSubject, incomeDataSubject, expendDataSubject].forEach { $0.subscribe { [weak self] buttonType in
            guard let self = self, let buttonType = buttonType.element else { return }
            selectedButtonIndexSubject.onNext(buttonType.rawValue)
        }.disposed(by: disposeBag) }
        
        // MARK: - Date 버튼 <-> DateString 바인딩
        [dateDecreaseButtonSubject, dateIncreaseButtonSubject].forEach { $0.subscribe { [weak self] dateButtonType in
            guard let dateButtonType = dateButtonType.element, let self = self else { return }
            repository.setDate(type: dateButtonType)
        }.disposed(by: disposeBag) }
        
        // MARK: - Date 버튼 <-> Date에 따른 불러오는 Entity 바인딩
        [dateDecreaseButtonSubject, dateIncreaseButtonSubject].forEach {
            $0.map { _ in (self.repository.readDate(), self.repository.readData()) }
            .subscribe { [weak self] emittedData in
            guard let (date, data) = emittedData.element, let self = self else {
                return
            }
            dateSubject.onNext(date)
            entitySubject.onNext(data)
        }.disposed(by: disposeBag) }
    }
}
