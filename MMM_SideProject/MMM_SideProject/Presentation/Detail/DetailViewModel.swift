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
    
    var selectedButtonIndexObservable : Observable<Int> { get }
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
    
    
    // MARK: - Observable (Subject)
    var selectedButtonIndexSubject : PublishSubject<Int>
    
    // MARK: - Observer
    var dateButtonObserver: AnyObserver<Void>
    var plusButtonObserver: AnyObserver<Void>
    var totalDataObserver: AnyObserver<Void>
    var incomeDataObserver: AnyObserver<Void>
    var expendDataObserver: AnyObserver<Void>
    
    
    // MARK: - Observable
    var selectedButtonIndexObservable: Observable<Int>
    
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
        
        // MARK: - Observable (Subject)
        selectedButtonIndexSubject = PublishSubject<Int>()
        
        // MARK: - Observer
        dateButtonObserver = dateButtonSubject.asObserver()
        plusButtonObserver = plusButtonSubject.asObserver()
        totalDataObserver = totalDataSubject.asObserver()
        incomeDataObserver = incomeDataSubject.asObserver()
        expendDataObserver = expendDataSubject.asObserver()
        
        // MARK: - Observable
        selectedButtonIndexObservable = selectedButtonIndexSubject
        
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
        
        totalDataSubject.map { ButtonType.total.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        incomeDataSubject.map { ButtonType.income.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
        
        expendDataSubject.map { ButtonType.expend.rawValue }
            .subscribe(onNext: selectedButtonIndexSubject.onNext)
            .disposed(by: disposeBag)
    }
}
