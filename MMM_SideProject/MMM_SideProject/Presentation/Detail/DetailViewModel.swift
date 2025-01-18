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
    var dateIncreaseButtonObserver : AnyObserver<Void> { get }
    var dateDecreaseButtonObserver : AnyObserver<Void> { get }
    
    var sectionModelObservable : Observable<[SectionModel]> { get }
    var selectedButtonIndexObservable : Observable<Int> { get }
    var dateObservable : Observable<String> { get }
    var monthObservable : Observable<String> { get }
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
    var incomeDataSubject : BehaviorSubject<ButtonType>
    var expendDataSubject : BehaviorSubject<ButtonType>
    var dateIncreaseButtonSubject : PublishSubject<Void>
    var dateDecreaseButtonSubject : PublishSubject<Void>
    
    
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
    var dateIncreaseButtonObserver: AnyObserver<Void>
    var dateDecreaseButtonObserver: AnyObserver<Void>
    
    
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
    
    weak var delegate : DetailViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // MARK: - Observer (Subject)
        dateButtonSubject = PublishSubject<Void>()
        plusButtonSubject = PublishSubject<Void>()
        totalDataSubject = BehaviorSubject<ButtonType>(value: .total)
        incomeDataSubject = BehaviorSubject<ButtonType>(value: .income)
        expendDataSubject = BehaviorSubject<ButtonType>(value: .expend)
        dateDecreaseButtonSubject = PublishSubject<Void>()
        dateIncreaseButtonSubject = PublishSubject<Void>()
        
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
        // TODO: Button 클릭시에 entitySubject 에 어떻게 보내야할까? - 트랜잭션
        [totalDataSubject, incomeDataSubject, expendDataSubject].forEach { $0.subscribe { [weak self] selectedButton in
            guard let self = self, let selectedButtonType = selectedButton.element else { return }
            repository.setState(type: selectedButtonType)
            entitySubject.onNext(repository.readData())
        }.disposed(by: disposeBag) }
        
        // MARK: - showButton <-> Color 바인딩
        // TODO: 묶어서 간략하게 코드를 작성할 수 있을 것 같음. (위에랑도 결합이 가능할 거 같음.)
        totalDataSubject.map { $0.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        incomeDataSubject.map { $0.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        expendDataSubject.map { $0.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        // MARK: - Date 버튼, DateString 바인딩
        dateDecreaseButtonSubject.subscribe { [weak self] _ in
            self?.repository.setDate(type: .decrease)
        }.disposed(by: disposeBag)
        
        dateIncreaseButtonSubject.subscribe { [weak self] _ in
            self?.repository.setDate(type: .increase)
        }.disposed(by: disposeBag)
        
        // MARK: - Date 버튼 클릭 -> 해당 날짜의 [Entity] 전파
        dateDecreaseButtonSubject.map { self.repository.readDate() }
            .subscribe { [weak self] stringDate in
                guard let stringDate = stringDate.element, let self = self else {
                    return
                }
                // TODO: 트랜지션을 고려할 필요가 있음. readTotalData() 가 만약 실패하면??
                dateSubject.onNext(stringDate)
                entitySubject.onNext(self.repository.readData())
            }.disposed(by: disposeBag)
        
        dateIncreaseButtonSubject.map { self.repository.readDate() }
            .subscribe { [weak self] stringDate in
                guard let stringDate = stringDate.element, let self = self else {
                    return
                }
                // TODO: 트랜지션을 고려할 필요가 있음. readTotalData() 가 만약 실패하면??
                dateSubject.onNext(stringDate)
                entitySubject.onNext(self.repository.readData())
            }.disposed(by: disposeBag)
    }
}
