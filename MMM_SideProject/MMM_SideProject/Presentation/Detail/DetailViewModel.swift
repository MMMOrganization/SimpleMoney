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

final class DetailViewModel : DetailViewModelInterface {
    
    var selectedData : Entity?
    
    var disposeBag : DisposeBag = .init()
    
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
        dateButtonSubject.subscribe(with: self) { owner, _ in
            owner.delegate?.pushCalendarVC()
        }.disposed(by: disposeBag)
        
        plusButtonSubject.subscribe(with: self) { owner, _ in
            owner.delegate?.pushCreateVC()
        }.disposed(by: disposeBag)
        
        graphButtonSubject.subscribe(with: self) { owner, _ in
            owner.delegate?.pushGraphVC()
        }.disposed(by: disposeBag)
    }
    
    func setBind() {
        // MARK: - viewWillAppear 셀 데이터 초기화 바인딩
        viewWillAppearSubject.subscribe(with: self) { owner, _ in
            owner.entitySubject.onNext(owner.repository.readData())
        }.disposed(by: disposeBag)
        
        // MARK: - showButton <-> Data 바인딩
        [totalDataSubject, incomeDataSubject, expendDataSubject].forEach {
            $0.subscribe(with: self) { owner, selectedButtonType in
                owner.repository.setState(type: selectedButtonType)
                owner.entitySubject.onNext(owner.repository.readData())
            }.disposed(by: disposeBag)
        }
        
        // MARK: - showButton <-> Color 바인딩
        [totalDataSubject, incomeDataSubject, expendDataSubject].forEach { $0.subscribe(with: self) { owner, buttonType in
                owner.selectedButtonIndexSubject.onNext(buttonType.rawValue)
            }.disposed(by: disposeBag)
        }
        
        // MARK: - Date 버튼 <-> DateString 바인딩
        [dateDecreaseButtonSubject, dateIncreaseButtonSubject].forEach {    $0.subscribe(with: self) { owner, dateButtonType in
                owner.repository.setDate(type: dateButtonType)
            }.disposed(by: disposeBag)
        }
        
        // MARK: - Date 버튼 <-> Date에 따른 불러오는 Entity 바인딩
        [dateDecreaseButtonSubject, dateIncreaseButtonSubject].forEach {
            $0.map { [weak self] _ in
                guard let self = self else { return ("", [Entity]()) }
                return (repository.readDate(), repository.readData())
            }
            .subscribe(with: self) { owner, emittedData in
                owner.dateSubject.onNext(emittedData.0)
                owner.entitySubject.onNext(emittedData.1)
            }.disposed(by: disposeBag)
        }
        
        // MARK: - Toast Delete 버튼 Click 바인딩
        selectedCellSubject.subscribe(with: self) { owner, entityData in
            owner.setSelectedData(entityData)
        }.disposed(by: disposeBag)
        
        // MARK: - Cell 삭제 바인딩
        removeCellSubject.subscribe(with: self) { owner, _ in
            guard let entityData = owner.getSelectedData() else { return }
            owner.repository.deleteData(id: entityData.id)
            owner.entitySubject.onNext(owner.repository.readData())
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

