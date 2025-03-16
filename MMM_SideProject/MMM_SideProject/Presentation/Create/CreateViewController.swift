//
//  CreateViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class CreateViewController: UIViewController {
    
    let disposeBag : DisposeBag = DisposeBag()
    var viewModel : CreateViewModelInterface!
    
    lazy var cancelButtonTag : Int = 999
    lazy var doneButtonTag : Int = 1000
    
    // MARK: - outLine (지출, 수입) 선택 애니메이션
    lazy var outLineViewLeadingAnchor = outLineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    lazy var outLineViewTrailingAnchor = outLineView.trailingAnchor.constraint(equalTo: self.expendButton.trailingAnchor)
    
    // MARK: - keyboardView 애니메이션
    lazy var keyboardHeight : CGFloat = 400
    lazy var keyboardBottomAnchor = keyboardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: keyboardHeight)
    
    // MARK: - dateToastView 애니메이션
    lazy var toastDateHeight : CGFloat = 250
    lazy var toastDateViewBottomAnchor = toastDateView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: toastDateHeight)
    
    // MARK: - Gesture 설정
    lazy var typeTapGesture = UITapGestureRecognizer()
    lazy var inputMoneyTapGesture = UITapGestureRecognizer()
    lazy var iconCVTapGesture = UITapGestureRecognizer()
    
    
    // MARK: - 각종 Layout에 적용될 View
    lazy var topStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [expendButton, incomeButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 0
        return sv
    }()
    
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftImage")?.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkImage")?.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        return button
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)
    lazy var saveButtonItem = UIBarButtonItem(customView: saveButton)
    
    let expendButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("지출", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.blackColor, for: .normal)
        button.layer.shouldRasterize = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let incomeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("수입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.blackColor, for: .normal)
        button.layer.shouldRasterize = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let outLineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    lazy var dateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(UIColor(hexCode: ColorConst.mainColorString, alpha: 0.20), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.blackColor, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let typeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .grayColor
        return label
    }()
    
    let typeHiddenTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isHidden = true
        tf.layer.shouldRasterize = true
        tf.layer.rasterizationScale = UIScreen.main.scale
        tf.keyboardType = .default
        return tf
    }()
    
    let inputMoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 35)
        label.textColor = .blackColor
        label.textAlignment = .center
        return label
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.70)
        return view
    }()
    
    let iconConstLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이콘"
        label.textColor = .blackColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var iconCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        
        let beforeItemSize = (view.frame.width - 30) / 4
        let itemSize = beforeItemSize - (beforeItemSize / 4)
        
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumInteritemSpacing = (itemSize / 4) // 아이템 사이 간격
        flowLayout.minimumLineSpacing = (itemSize / 4) // 줄 간격
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let keyboardView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        return v
    }()
    
    lazy var toastDateView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    let toastDatePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.overrideUserInterfaceStyle = .light
        picker.locale = Locale(identifier: "ko_KR")
        return picker
    }()
    
    lazy var keyboardStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        let firstSV : UIStackView = createHorizonStackView(arr : [1, 2, 3])
        let secondSV : UIStackView = createHorizonStackView(arr : [4, 5, 6])
        let thirdSV : UIStackView = createHorizonStackView(arr : [7, 8, 9])
        let fourthSV : UIStackView = createHorizonStackView(arr: [doneButtonTag, 0, cancelButtonTag])
        [firstSV, secondSV, thirdSV, fourthSV].forEach { sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    func createHorizonStackView(arr : [Int]) -> UIStackView {
        lazy var stackView : UIStackView = {
            let sv = UIStackView()
            arr.forEach { sv.addArrangedSubview(createKeyboardButton(num: $0)) }
            sv.axis = .horizontal
            sv.spacing = 0
            sv.alignment = .fill
            sv.distribution = .fillEqually
            return sv
        }()
        
        return stackView
    }
    
    // MARK: - Initializer
    init(viewModel: CreateViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("CreateViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionView()
        setGesture()
        setToastReactive()
        setReactive()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dateButton.layer.cornerRadius = dateButton.frame.height / 2
    }
    
    func setCollectionView() {
        iconCollectionView.dataSource = nil
        
        iconCollectionView.register(CreateCollectionViewCell.self, forCellWithReuseIdentifier: CreateCollectionViewCell.identifier)
    }
    
    func setGesture() {
        typeLabel.addGestureRecognizer(typeTapGesture)
        typeLabel.isUserInteractionEnabled = true
        
        inputMoneyLabel.addGestureRecognizer(inputMoneyTapGesture)
        inputMoneyLabel.isUserInteractionEnabled = true
        
        // 중요: 다른 터치 이벤트 영향 안주게 설정
        iconCVTapGesture.cancelsTouchesInView = false
        iconCollectionView.addGestureRecognizer(iconCVTapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        typeHiddenTextField.resignFirstResponder()
        customKeyboardResign()
        resignToastDateView()
    }
    
    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        navigationItem.leftBarButtonItem = dismissButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        
        view.backgroundColor = .white
        view.addSubview(topStackView)
        view.addSubview(outLineView)
        view.addSubview(dateButton)
        view.addSubview(typeLabel)
        view.addSubview(typeHiddenTextField)
        view.addSubview(inputMoneyLabel)
        view.addSubview(iconConstLabel)
        view.addSubview(iconCollectionView)
        view.addSubview(keyboardView)
        view.addSubview(toastDateView)
        
        toastDateView.addSubview(toastDatePicker)
        
        keyboardView.addSubview(keyboardStackView)
        
        NSLayoutConstraint.activate([
            // MARK: - 지출 수입 버튼 Layout
            expendButton.heightAnchor.constraint(equalToConstant: 35),
            incomeButton.heightAnchor.constraint(equalToConstant: 35),
            
            // MARK: - topStackView Layout
            topStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // MARK: - outLineView Layout (Animate)
            outLineViewLeadingAnchor,
            outLineViewTrailingAnchor,
            outLineView.heightAnchor.constraint(equalToConstant: 1),
            outLineView.topAnchor.constraint(equalTo: self.topStackView.bottomAnchor),
            
            // MARK: - dateButton Layout
            dateButton.topAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: 15),
            dateButton.widthAnchor.constraint(equalToConstant: 200),
            dateButton.heightAnchor.constraint(equalToConstant: 30),
            dateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - typeLabel Layout
            typeLabel.topAnchor.constraint(equalTo: self.dateButton.bottomAnchor, constant: 15),
            typeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // MARK: - typeHiddenTextField Layout
            typeHiddenTextField.centerXAnchor.constraint(equalTo: self.typeLabel.centerXAnchor),
            typeHiddenTextField.topAnchor.constraint(equalTo: self.typeLabel.topAnchor),
            typeHiddenTextField.heightAnchor.constraint(equalToConstant: 20),
            
            // MARK: - inputMoneyLabel Layout
            inputMoneyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inputMoneyLabel.topAnchor.constraint(equalTo: self.typeLabel.bottomAnchor, constant: 15),
            
            // MARK: - iconConstLabel Layout
            iconConstLabel.topAnchor.constraint(equalTo: self.inputMoneyLabel.bottomAnchor, constant: 20),
            iconConstLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            
            // MARK: - iconCollectionView Layout
            iconCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            iconCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            iconCollectionView.topAnchor.constraint(equalTo: self.iconConstLabel.bottomAnchor, constant: 10),
            iconCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            // MARK: - keyboardView Layout
            keyboardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight),
            keyboardBottomAnchor,
            
            keyboardStackView.leadingAnchor.constraint(equalTo: self.keyboardView.leadingAnchor),
            keyboardStackView.trailingAnchor.constraint(equalTo: self.keyboardView.trailingAnchor),
            keyboardStackView.topAnchor.constraint(equalTo: self.keyboardView.topAnchor),
            keyboardStackView.bottomAnchor.constraint(equalTo: self.keyboardView.bottomAnchor),
        ])
        
        // MARK: - ToastDate Layout
        NSLayoutConstraint.activate([
            toastDateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            toastDateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            toastDateView.heightAnchor.constraint(equalToConstant: toastDateHeight),
            toastDateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastDateViewBottomAnchor,
            
            toastDatePicker.centerXAnchor.constraint(equalTo: self.toastDateView.centerXAnchor),
            toastDatePicker.topAnchor.constraint(equalTo: self.toastDateView.topAnchor, constant: 20),
        ])
    }
    
    func setReactive() {
        // MARK: - Coordinator 패턴
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Gesture 바인딩
        typeTapGesture.rx.event
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                typeHiddenTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        inputMoneyTapGesture.rx.event
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                customKeyboardBecome()
            }.disposed(by: disposeBag)
        
        iconCVTapGesture.rx.event
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                customKeyboardResign()
                typeHiddenTextField.resignFirstResponder()
                resignToastDateView()
            }.disposed(by: disposeBag)
        
        // MARK: - SaveButton 바인딩
        saveButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.completeButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - 지출, 수입 버튼 바인딩
        expendButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { .expend }
            .bind(to: viewModel.createTypeObserver)
            .disposed(by: disposeBag)
        
        incomeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { .income }
            .bind(to: viewModel.createTypeObserver)
            .disposed(by: disposeBag)
        
        // MARK: - 지출 버튼 클릭했을 때의 애니메이션 작동
        expendButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                if outLineViewLeadingAnchor.constant > 0 {
                    outLineViewLeadingAnchor.constant -= topStackView.frame.width / 2
                    outLineViewTrailingAnchor.constant -= topStackView.frame.width / 2
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
        
        // MARK: - 수입 버튼 클릭했을 때의 애니메이션 작동
        incomeButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                if outLineViewLeadingAnchor.constant <= 0 {
                    outLineViewLeadingAnchor.constant += topStackView.frame.width / 2
                    outLineViewTrailingAnchor.constant += topStackView.frame.width / 2
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
        
        // MARK: - CollectionView 데이터 바인딩
        viewModel.dataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: iconCollectionView.rx.items(cellIdentifier: CreateCollectionViewCell.identifier, cellType: CreateCollectionViewCell.self)) { (index, item, cell) in
                cell.configure(item : item)
            }.disposed(by: disposeBag)
        
        // MARK: - Date 날짜 바인딩
        viewModel.stringDateObservable
            .observe(on: MainScheduler.instance)
            .bind(to: dateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        // MARK: - 지출, 수입 타입 바인딩
        typeHiddenTextField.rx.text
            .observe(on: MainScheduler.instance)
            .map { [weak self] in
                guard let self = self else { return "" }
                if ((0...8) ~= (typeHiddenTextField.text?.count ?? 0)) {
                    return $0 ?? ""
                }
                else {
                    typeHiddenTextField.text = (typeHiddenTextField.text ?? "").map { String($0) }[0..<8].joined()
                    return $0 ?? ""
                }
            }
            .bind(to: viewModel.keyboardTypeTapObserver)
            .disposed(by: disposeBag)
        
        viewModel.stringTypeObservable
            .observe(on: MainScheduler.instance)
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - inputMoney View 바인딩
        viewModel.inputMoneyObservable
            .observe(on: MainScheduler.instance)
            .bind(to: inputMoneyLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - CreateCell iconImage 클릭 시에 인덱스 바인딩
        iconCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedCellIndexObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Create 과정에서 발생하는 에러 종류 바인딩
        viewModel.errorObservable
            .subscribe { errorType in
                guard let errorMessage = errorType.element?.description else { return }
                
                ToastManager.shared.showToast(message: errorMessage)
            }.disposed(by: disposeBag)
        
        dateButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                becomeToastDateView()
                typeHiddenTextField.resignFirstResponder()
                customKeyboardResign()
            }.disposed(by: disposeBag)
    }
}


// MARK: - Custom Keyboard, KeyBoard Method
private extension CreateViewController {
    func customKeyboardResign() {
        if keyboardBottomAnchor.constant == keyboardHeight { return }
        
        keyboardBottomAnchor.constant = keyboardHeight
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
    
    func customKeyboardBecome() {
        if keyboardBottomAnchor.constant == 0 { return }
        
        keyboardBottomAnchor.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - KeyBoardView에 들어갈 StackView의 버튼 생성
    func createKeyboardButton(num : Int) -> UIButton {
        switch num {
        case doneButtonTag:
            lazy var button : UIButton = {
                let b = UIButton()
                b.translatesAutoresizingMaskIntoConstraints = false
                b.setImage(UIImage(named: "checkImage")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
                b.backgroundColor = .white
                b.tag = num
                setKeyboardTapBinding(b)
                return b
            }()
            return button
        case cancelButtonTag:
            lazy var button : UIButton = {
                let b = UIButton()
                b.translatesAutoresizingMaskIntoConstraints = false
                b.setImage(UIImage(named: "closeButton")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
                b.backgroundColor = .white
                b.tag = num
                setKeyboardTapBinding(b)
                return b
            }()
            return button
        default:
            lazy var button : UIButton = {
                let b = UIButton()
                b.translatesAutoresizingMaskIntoConstraints = false
                b.titleLabel?.textAlignment = .center
                b.setTitleColor(.blackColor, for: .normal)
                b.setTitle(String(num), for: .normal)
                b.backgroundColor = .white
                b.tag = num
                b.titleLabel?.font = UIFont(size: 18)
                setKeyboardTapBinding(b)
                return b
            }()
            return button
        }
    }
    
    func setKeyboardTapBinding(_ button : UIButton) {
        switch button.tag {
        case doneButtonTag:
            button.rx.tap
                .subscribe { [weak self] _ in
                    guard let self = self else { return }
                    customKeyboardResign()
                }.disposed(by: disposeBag)
        case cancelButtonTag:
            button.rx.tap
                .observe(on: MainScheduler.instance)
                .bind(to: viewModel.keyboardCancelTapObserver)
                .disposed(by: disposeBag)
        default:
            button.rx.tap
                .observe(on: MainScheduler.instance)
                .map { String(button.tag) }
                .bind(to: viewModel.keyboardNumberTapObserver)
                .disposed(by: disposeBag)
        }
    }
}


// MARK: - DateToastView Method
private extension CreateViewController {
    func setToastReactive() {
        // MARK: - Date를 설정할 때마다 Date를 추적하는 스트림
        toastDatePicker.rx.date
            .observe(on: MainScheduler.instance)
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: $0)
                return formattedDate
            }
            .bind(to: viewModel.stringDateObserver)
            .disposed(by: disposeBag)
    }
    
    func resignToastDateView() {
        if toastDateViewBottomAnchor.constant == toastDateHeight { return }
        
        toastDateViewBottomAnchor.constant = toastDateHeight
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
    
    func becomeToastDateView() {
        if toastDateViewBottomAnchor.constant == 0 { return }
        
        toastDateViewBottomAnchor.constant = 0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
}


