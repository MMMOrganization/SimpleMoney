//
//  CreateViewModel.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

protocol CreateViewModelInterface {
    var dismissButtonObserver : AnyObserver<Void> { get }
    var completeButtonObserver : AnyObserver<Void> { get }
    var createTypeObserver : AnyObserver<CreateType> { get }
    var stringDateObserver : AnyObserver<String> { get }
    var stringTypeObserver : AnyObserver<String> { get }
    var inputMoneyObserver : AnyObserver<String> { get }
    var keyboardTypeTapObserver : AnyObserver<String> { get }
    var keyboardNumberTapObserver : AnyObserver<String> { get }
    var keyboardCancelTapObserver : AnyObserver<Void> { get }
    var selectedCellIndexObserver : AnyObserver<Int> { get }
    
    var dataObservable : Observable<[CreateCellIcon]> { get }
    var stringDateObservable : Observable<String> { get }
    var stringTypeObservable : Observable<String> { get }
    var inputMoneyObservable : Observable<String> { get }
    var errorObservable : Observable<CreateError> { get }
}

protocol CreateViewModelDelegate : AnyObject {
    func popCreateVC()
}

final class CreateViewModel : CreateViewModelInterface {
    
    var inputMoney : String = ""
    var dateString : String?
    var typeString : String?
    var iconImageType : IconImageType = .date
    var createType : CreateType = .expend
    
    var disposeBag : DisposeBag = DisposeBag()
    
    // MARK: - Subject Observer
    var dismissButtonSubject: PublishSubject<Void>
    var createTypeSubject : BehaviorSubject<CreateType>
    var stringDateSubject : BehaviorSubject<String>
    var stringTypeSubject : BehaviorSubject<String>
    var inputMoneySubject : BehaviorSubject<String>
    var selectedCellIndexSubject : BehaviorSubject<Int>
    var completeButtonSubject : PublishSubject<Void>
    var keyboardTypeTapSubject : PublishSubject<String>
    var keyboardNumberTapSubject : PublishSubject<String>
    var keyboardCancelTapSubject : PublishSubject<Void>
    
    // MARK: - Subject Observable
    var dataSubject : BehaviorSubject<[CreateCellIcon]>
    var errorSubject : PublishSubject<CreateError>
    
    // MARK: - Observer
    var dismissButtonObserver: AnyObserver<Void>
    var createTypeObserver: AnyObserver<CreateType>
    var stringDateObserver: AnyObserver<String>
    var stringTypeObserver: AnyObserver<String>
    var inputMoneyObserver: AnyObserver<String>
    var selectedCellIndexObserver: AnyObserver<Int>
    var completeButtonObserver: AnyObserver<Void>
    var keyboardTypeTapObserver: AnyObserver<String>
    var keyboardNumberTapObserver: AnyObserver<String>
    var keyboardCancelTapObserver: AnyObserver<Void>
    
    // MARK: - Observable
    var dataObservable: Observable<[CreateCellIcon]>
    var stringDateObservable: Observable<String>
    var errorObservable: Observable<CreateError>

    // MARK: - Lazy Observable (다른 Observable에 스트림이 이어진 관계)
    lazy var inputMoneyObservable : Observable<String> = inputMoneySubject
        .map {
            if $0 == "" { return "0원" }
            guard let intValue = Int($0) else { return "" }
            return intValue.absToCurrency
        }
    
    lazy var stringTypeObservable : Observable<String> = stringTypeSubject
        .map { $0 }
    
    weak var delegate : CreateViewModelDelegate?
    
    var repository : DataRepositoryInterface
    
    init(repository: DataRepositoryInterface) {
        self.repository = repository
        
        dismissButtonSubject = PublishSubject<Void>()
        createTypeSubject = BehaviorSubject<CreateType>(value: .expend)
        stringDateSubject = BehaviorSubject<String>(value: repository.readDate())
        stringTypeSubject = BehaviorSubject<String>(value: "기타")
        inputMoneySubject = BehaviorSubject<String>(value: "")
        selectedCellIndexSubject = BehaviorSubject<Int>(value: 0)
        completeButtonSubject = PublishSubject<Void>()
        keyboardTypeTapSubject = PublishSubject<String>()
        keyboardNumberTapSubject = PublishSubject<String>()
        keyboardCancelTapSubject = PublishSubject<Void>()
        errorSubject = PublishSubject<CreateError>()
        
        dataSubject = BehaviorSubject<[CreateCellIcon]>(value: repository.readInitIconCell())
        
        
        dismissButtonObserver = dismissButtonSubject.asObserver()
        createTypeObserver = createTypeSubject.asObserver()
        stringDateObserver = stringDateSubject.asObserver()
        stringTypeObserver = stringTypeSubject.asObserver()
        inputMoneyObserver = inputMoneySubject.asObserver()
        selectedCellIndexObserver = selectedCellIndexSubject.asObserver()
        completeButtonObserver = completeButtonSubject.asObserver()
        keyboardTypeTapObserver = keyboardTypeTapSubject.asObserver()
        keyboardNumberTapObserver = keyboardNumberTapSubject.asObserver()
        keyboardCancelTapObserver = keyboardCancelTapSubject.asObserver()
        
        dataObservable = dataSubject
        stringDateObservable = stringDateSubject
        errorObservable = errorSubject
        
        setReactive()
    }
    
    func setReactive() {
        dismissButtonSubject.subscribe(with: self) { owner, _ in
            owner.delegate?.popCreateVC()
        }.disposed(by: disposeBag)
        
        // MARK: - 저장버튼과의 바인딩 (예외 처리)
        // MARK: - [weak self] 를 사용해서 얻는 이점이 더 많음.
        completeButtonSubject.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            guard let dateString = dateString else { return }
            
            guard dateString.split(separator: "년").count <= 1 else {
                errorSubject.onNext(.noneSetDate)
                return
            }
            
            guard let money = Int(inputMoney), money > 0 else {
                errorSubject.onNext(.zeroInputMoney)
                return
            }
            
            // MARK: - Realm 디비 저장
            guard let typeString = typeString else {
                return
            }
            
            guard let realm = try? Realm() else {
                errorSubject.onNext(.dataBaseError)
                return
            }
            
            let userDB = UserDB(createType: createType, moneyAmount: inputMoney.toAmount(with: createType), iconImageType: iconImageType, typeString: typeString, dateString: dateString)
            
            try! realm.write {
                realm.add(userDB)
            }
            
            delegate?.popCreateVC()
        }.disposed(by: disposeBag)
        
        // MARK: - CreateCell Icon 과 지출, 수입 버튼의 바인딩
        createTypeSubject.subscribe(with: self) { owner, createType in
            owner.setCreateType(createType)
            owner.dataSubject.onNext(owner.repository.readInitIconCell())
        }.disposed(by: disposeBag)
        
        // MARK: - CreateCell Click 바인딩
        selectedCellIndexSubject.subscribe(with: self) { owner, index in
            owner.repository.setSelectedIconCell(index: index)
            owner.dataSubject.onNext(owner.repository.readIconCell())
            owner.setIconImageType(owner.repository.readSelectedIconImageType(index: index))
        }.disposed(by: disposeBag)
        
        // MARK: - Date 클릭시에 ViewModel이 가지는 dateString과의 바인딩
        stringDateSubject.subscribe(with: self) { owner, stringDate in
            owner.setDateString(stringDate)
        }.disposed(by: disposeBag)
        
        // MARK: - 타입 클릭시에 ViewModel이 가지는 typeLabel과의 바인딩
        keyboardTypeTapSubject.subscribe(with: self) { owner, stringType in
            guard stringType != "" else {
                owner.stringTypeSubject.onNext("기타")
                owner.setTypeString("기타")
                return
            }
            
            guard (0...8) ~= stringType.count else {
                return
            }
            
            owner.setTypeString(stringType)
            owner.stringTypeSubject.onNext(owner.getTypeString())
        }.disposed(by: disposeBag)
        
        // MARK: - Custom KeyBoard 숫자 탭과의 바인딩
        keyboardNumberTapSubject.subscribe(with: self) { owner, number in
            guard (0...10) ~= owner.getInputMoney().count else {
                return
            }
            
            owner.plusInputMoney(number)
            owner.inputMoneySubject.onNext(owner.getInputMoney())
        }.disposed(by: disposeBag)
        
        // MARK: - Custom KeyBoard 취소 탭과의 바인딩
        keyboardCancelTapSubject.subscribe(with: self) { owner, _ in
            owner.minusInputMoney()
            owner.inputMoneySubject.onNext(owner.getInputMoney())
        }.disposed(by: disposeBag)
    }
    
    deinit {
        print("CreateViewModel - 메모리 해제")
    }
}

extension CreateViewModel {
    // MARK: - Property Get
    func getInputMoney() -> String {
        return inputMoney
    }
    
    func getTypeString() -> String {
        return typeString ?? ""
    }
    
    func getCreateType() -> CreateType {
        return createType
    }
    
    // MARK: - Property Set
    func plusInputMoney(_ num : String) {
        //0을 계속 클릭하면 000000.. 하고 계속 늘어나는 것을 막기 위해
        guard let inputMoneyAmount = Int("\(inputMoney)\(num)") else { return }
        inputMoney = String(inputMoneyAmount)
    }
    
    func minusInputMoney() {
        guard let money = Int(inputMoney) else { return }
        inputMoney = String(money / 10)
    }
    
    func setTypeString(_ typeName : String) {
        typeString = typeName
    }
    
    func setIconImageType(_ imagetype : IconImageType) {
        iconImageType = imagetype
    }
    
    func setDateString(_ str : String) {
        dateString = str
    }
    
    func setCreateType(_ type : CreateType) {
        createType = type
    }
}
