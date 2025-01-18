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
    var totalDataObserver : AnyObserver<Void> { get }
    var incomeDataObserver : AnyObserver<Void> { get }
    var expendDataObserver : AnyObserver<Void> { get }
    var dateIncreaseButtonObserver : AnyObserver<Void> { get }
    var dateDecreaseButtonObserver : AnyObserver<Void> { get }
    
    var selectedButtonIndexObservable : Observable<Int> { get }
    var dateObservable : Observable<String> { get }
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
    var totalDataSubject : PublishSubject<Void>
    var incomeDataSubject : PublishSubject<Void>
    var expendDataSubject : PublishSubject<Void>
    var dateIncreaseButtonSubject : PublishSubject<Void>
    var dateDecreaseButtonSubject : PublishSubject<Void>
    
    
    // MARK: - Observable (Subject)
    var selectedButtonIndexSubject : PublishSubject<Int>
    var dateSubject : PublishSubject<String>
    
    // MARK: - Observer
    var dateButtonObserver: AnyObserver<Void>
    var plusButtonObserver: AnyObserver<Void>
    var totalDataObserver: AnyObserver<Void>
    var incomeDataObserver: AnyObserver<Void>
    var expendDataObserver: AnyObserver<Void>
    var dateIncreaseButtonObserver: AnyObserver<Void>
    var dateDecreaseButtonObserver: AnyObserver<Void>
    
    
    // MARK: - Observable
    var selectedButtonIndexObservable: Observable<Int>
    var dateObservable: Observable<String>
    
    weak var delegate : DetailViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        // MARK: - Observer (Subject)
        dateButtonSubject = PublishSubject<Void>()
        plusButtonSubject = PublishSubject<Void>()
        totalDataSubject = PublishSubject<Void>()
        incomeDataSubject = PublishSubject<Void>()
        expendDataSubject = PublishSubject<Void>()
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
        totalDataSubject.subscribe { [weak self] _ in
            guard let entityList = self?.repository.readTotalData() else { return }
            dump(entityList)
        }.disposed(by: disposeBag)
        
        incomeDataSubject.subscribe { [weak self] _ in
            guard let entityList = self?.repository.readIncomeData() else { return }
            dump(entityList)
        }.disposed(by: disposeBag)
        
        expendDataSubject.subscribe { [weak self] _ in
            guard let entityList = self?.repository.readExpendData() else { return }
            dump(entityList)
        }.disposed(by: disposeBag)
        
        // MARK: - showButton <-> Color 바인딩
        totalDataSubject.map { ButtonType.total.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        incomeDataSubject.map { ButtonType.income.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        expendDataSubject.map { ButtonType.expend.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        // MARK: - Date 버튼, DateString 바인딩
        dateDecreaseButtonSubject.subscribe { [weak self] _ in
            self?.repository.setDate(type: .decrease)
        }.disposed(by: disposeBag)
        
        dateIncreaseButtonSubject.subscribe { [weak self] _ in
            self?.repository.setDate(type: .increase)
        }.disposed(by: disposeBag)
        
        // 전파될 때 그 날짜의 데이터로 가져와야 함.
        dateDecreaseButtonSubject.map { self.repository.readDate() }
            .subscribe(onNext: dateSubject.onNext)
            .disposed(by: disposeBag)
        
        dateIncreaseButtonSubject.map { self.repository.readDate() }
            .subscribe(onNext: dateSubject.onNext)
            .disposed(by: disposeBag)
    }
}
