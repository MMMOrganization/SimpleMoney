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
    var viewWillAppearObserver : AnyObserver<Void> { get }
    var graphButtonObserver : AnyObserver<Void> { get }
    var selectedCellObserver : AnyObserver<Entity> { get }
    var removeCellObserver : AnyObserver<Void> { get }
    
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
    func pushGraphVC()
}

class DetailViewModel : DetailViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var selectedData : Entity?
    
    // MARK: - Observer (Subject)
    var dateButtonSubject : PublishSubject<Void>
    var plusButtonSubject : PublishSubject<Void>
    var viewWillAppearSubject : PublishSubject<Void>
    var graphButtonSubject : PublishSubject<Void>
    var totalDataSubject : BehaviorSubject<ButtonType>
    var incomeDataSubject : PublishSubject<ButtonType>
    var expendDataSubject : PublishSubject<ButtonType>
    var dateIncreaseButtonSubject : PublishSubject<DateButtonType>
    var dateDecreaseButtonSubject : PublishSubject<DateButtonType>
    var selectedCellSubject : PublishSubject<Entity>
    var removeCellSubject : PublishSubject<Void>
    
    
    // MARK: - Observable (Subject)
    var selectedButtonIndexSubject : PublishSubject<Int>
    var dateSubject : PublishSubject<String>
    var entitySubject : BehaviorSubject<[Entity]> = BehaviorSubject<[Entity]>(value: [])
    var sectionModelSubject : BehaviorSubject<[SectionModel]> = BehaviorSubject<[SectionModel]>(value: [])
    
    // MARK: - Observer
    var dateButtonObserver: AnyObserver<Void>
    var plusButtonObserver: AnyObserver<Void>
    var viewWillAppearObserver: AnyObserver<Void>
    var graphButtonObserver: AnyObserver<Void>
    var totalDataObserver: AnyObserver<ButtonType>
    var incomeDataObserver: AnyObserver<ButtonType>
    var expendDataObserver: AnyObserver<ButtonType>
    var dateIncreaseButtonObserver: AnyObserver<DateButtonType>
    var dateDecreaseButtonObserver: AnyObserver<DateButtonType>
    var selectedCellObserver: AnyObserver<Entity>
    var removeCellObserver: AnyObserver<Void>
    
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
        
        return tempDictionary.sorted { $0.key > $1.key }.map {
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
        viewWillAppearSubject = PublishSubject<Void>()
        graphButtonSubject = PublishSubject<Void>()
        totalDataSubject = BehaviorSubject<ButtonType>(value: .total)
        incomeDataSubject = PublishSubject<ButtonType>()
        expendDataSubject = PublishSubject<ButtonType>()
        dateDecreaseButtonSubject = PublishSubject<DateButtonType>()
        dateIncreaseButtonSubject = PublishSubject<DateButtonType>()
        selectedCellSubject = PublishSubject<Entity>()
        removeCellSubject = PublishSubject<Void>()
        
        // MARK: - Observable (Subject)
        selectedButtonIndexSubject = PublishSubject<Int>()
        dateSubject = PublishSubject<String>()
        
        // MARK: - Observer
        dateButtonObserver = dateButtonSubject.asObserver()
        plusButtonObserver = plusButtonSubject.asObserver()
        viewWillAppearObserver = viewWillAppearSubject.asObserver()
        graphButtonObserver = graphButtonSubject.asObserver()
        totalDataObserver = totalDataSubject.asObserver()
        incomeDataObserver = incomeDataSubject.asObserver()
        expendDataObserver = expendDataSubject.asObserver()
        dateDecreaseButtonObserver = dateDecreaseButtonSubject.asObserver()
        dateIncreaseButtonObserver = dateIncreaseButtonSubject.asObserver()
        selectedCellObserver = selectedCellSubject.asObserver()
        removeCellObserver = removeCellSubject.asObserver()
        
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
        
        graphButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.pushGraphVC()
        }.disposed(by: disposeBag)
    }
    
    func setBind() {
        // MARK: - viewWillAppear 셀 데이터 초기화 바인딩
        viewWillAppearSubject.subscribe { [weak self] _ in
            guard let self = self else { return }
            entitySubject.onNext(repository.readData())
        }.disposed(by: disposeBag)
        
        // MARK: - showButton <-> Data 바인딩
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
            $0.map { [weak self] _ in
                guard let self = self else { return ("", [Entity]()) }
                return (repository.readDate(), repository.readData())
            }
            .subscribe { [weak self] emittedData in
            guard let (date, data) = emittedData.element, let self = self else {
                return
            }
            dateSubject.onNext(date)
            entitySubject.onNext(data)
        }.disposed(by: disposeBag) }
        
        // MARK: - Toast Delete 버튼 Click 바인딩
        selectedCellSubject.subscribe { [weak self] entityData in
            guard let self = self, let entityData = entityData.element else { return }
            setSelectedData(entityData)
        }.disposed(by: disposeBag)
        
        removeCellSubject.subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let entityData = getSelectedData() else { return }
            repository.deleteData(id: entityData.id)
            entitySubject.onNext(repository.readData())
        }.disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    func setSelectedData(_ data : Entity) {
        selectedData = data
    }
    
    func getSelectedData() -> Entity? {
        return selectedData
    }
}

