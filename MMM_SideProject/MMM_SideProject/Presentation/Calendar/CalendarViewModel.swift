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
}



class CalendarViewModel : CalendarViewModelInterface {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var dismissButtonSubject: PublishSubject<Void>
    
    var dismissButtonObserver: AnyObserver<Void>
    
    weak var delegate : CalendarViewModelDelegate?
    
    init() {
        dismissButtonSubject = PublishSubject<Void>()
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        
        setReactive()
    }
    
    func setReactive() {
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popCalendarVC()
        }.disposed(by: disposeBag)
    }
}
