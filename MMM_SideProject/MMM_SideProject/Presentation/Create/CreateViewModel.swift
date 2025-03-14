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

class CreateViewModel : CreateViewModelInterface {
    
    // TODO: - ViewModel에서 Create로 만들어진 구조체가 있어야 함.
    // TODO: - 구조체를 통해서 Realm 에 Create를 진행해야 함.
    
    var inputMoney : String = ""
    var dateString : String?
    var typeString : String?
    var iconImage : UIImage?
    var createType : CreateType = .expend
    
    var disposeBag : DisposeBag = DisposeBag()
    
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
    
    var dataSubject : BehaviorSubject<[CreateCellIcon]>
    var errorSubject : PublishSubject<CreateError>
    
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
    
    init(repository : DataRepositoryInterface) {
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
        
        dataSubject = BehaviorSubject<[CreateCellIcon]>(value: repository.readDataForCreateCell(of: createType, selectedIndex: 0))
        
        
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
        dismissButtonSubject.subscribe { [weak self] _ in
            self?.delegate?.popCreateVC()
        }.disposed(by: disposeBag)
        
        // MARK: - 저장버튼과의 바인딩 (예외 처리)
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
            
            let userDB = UserDB(createType: createType, moneyAmount: inputMoney.toAmount(with: createType), iconImageType: .date, typeString: typeString, dateString: dateString)
            
            try! realm.write {
                realm.add(userDB)
            }
            
            self.delegate?.popCreateVC()
        }.disposed(by: disposeBag)
        
        // MARK: - CreateCell Icon 과 지출, 수입 버튼의 바인딩
        createTypeSubject.subscribe { [weak self] createType in
            guard let self = self, let createType = createType.element else { return }
            self.createType = createType
            stringDateSubject.onNext(repository.readDate())
            dataSubject.onNext(repository.readDataForCreateCell(of: createType, selectedIndex: 0))
        }.disposed(by: disposeBag)
        
        // MARK: - CreateCell Click 바인딩
        selectedCellIndexSubject.subscribe { [weak self] indexPath in
            guard let self = self, let index = indexPath.element else { return }
            dataSubject.onNext(repository.readDataForCreateCell(of: createType, selectedIndex: index))
            
            self.iconImage = CreateCellIcon.readIconImage(at: index)
            // TODO: - iconImage 받아와야 함.
        }.disposed(by: disposeBag)
        
        // MARK: - Date 클릭시에 ViewModel이 가지는 dateString과의 바인딩
        stringDateSubject.subscribe { [weak self] stringDate in
            guard let self = self, let stringDate = stringDate.element else { return }
            self.dateString = stringDate
        }.disposed(by: disposeBag)
        
        // MARK: - 타입 클릭시에 ViewModel이 가지는 typeLabel과의 바인딩
        keyboardTypeTapSubject.subscribe { [weak self] stringType in
            guard let self = self, let stringType = stringType.element else { return }
            
            print(stringType)
            
            guard stringType != "" else {
                stringTypeSubject.onNext("기타")
                return
            }
            
            guard (0...12) ~= stringType.count else {
                return
            }
        
            guard !(getTypeString().isEmpty && stringType == " ") else {
                return
            }
            
            setTypeString(stringType)
            stringTypeSubject.onNext(getTypeString())
        }.disposed(by: disposeBag)
        
        // MARK: - Custom KeyBoard 숫자 탭과의 바인딩
        keyboardNumberTapSubject.subscribe { [weak self] tappedNumber in
            guard let self = self, let number = tappedNumber.element else { return }
            
            guard (0...10) ~= getInputMoney().count else {
                return
            }
            
            plusInputMoney(number)
            inputMoneySubject.onNext(getInputMoney())
            print(getInputMoney())
        }.disposed(by: disposeBag)
        
        // MARK: - Custom KeyBoard 취소 탭과의 바인딩
        keyboardCancelTapSubject.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            minusInputMoney()
            inputMoneySubject.onNext(getInputMoney())
        }.disposed(by: disposeBag)
    }
}

extension CreateViewModel {
    // MARK: - InputMoney 조정
    func getInputMoney() -> String {
        return inputMoney
    }
    
    func getTypeString() -> String {
        return typeString ?? ""
    }
    
    func plusInputMoney(_ num : String) {
        //0을 계속 클릭하면 000000.. 하고 계속 늘어나는 것을 막기 위해
        guard let inputMoneyAmount = Int("\(inputMoney)\(num)") else { return }
        self.inputMoney = String(inputMoneyAmount)
    }
    
    func minusInputMoney() {
        guard let money = Int(inputMoney) else { return }
        inputMoney = String(money / 10)
    }
    
    func setTypeString(_ typeName : String) {
        self.typeString = typeName
    }
}
