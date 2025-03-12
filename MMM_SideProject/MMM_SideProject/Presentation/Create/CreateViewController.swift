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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(named: "checkImage"), for: .normal)
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
        button.setTitle(YearMonthDay().toStringYearMonthDay(), for: .normal)
        button.setBackgroundColor(UIColor(hexCode: ColorConst.mainColorString, alpha: 0.20), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(buttontapped), for: .touchUpInside)
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
        tf.keyboardType = .default
        return tf
    }()
    
    let inputMoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 35)
        label.textAlignment = .center
        return label
    }()
    
    let inputMoneyHiddenTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isHidden = true
        tf.keyboardType = .numberPad
        return tf
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
    
    let iconCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //let tempWidth = (UIScreen.main.bounds.width - 15 * 3) / 4
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 70, height: 70)
        flowLayout.minimumInteritemSpacing = 23 // 아이템 사이 간격
        flowLayout.minimumLineSpacing = 20 // 줄 간격
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
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
        let typeTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeLabelClicked))
        typeLabel.addGestureRecognizer(typeTapGesture)
        typeLabel.isUserInteractionEnabled = true
        
        let inputMoneyTapGesture = UITapGestureRecognizer(target: self, action: #selector(inputMoneyClicked))
        inputMoneyLabel.addGestureRecognizer(inputMoneyTapGesture)
        inputMoneyLabel.isUserInteractionEnabled = true
    }
    
    // TODO: - Lagacy (바인딩으로 변경 필요)
    @objc func buttontapped() {
        let dateVC = DateToastView(viewModel: viewModel)
        addChild(dateVC)
        view.addSubview(dateVC.view)
        dateVC.didMove(toParent: self)
        
        dateVC.view.frame = view.bounds
    }
    
    // MARK: - KeyBoard 비활성화
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.inputMoneyHiddenTextField.resignFirstResponder()
        self.typeHiddenTextField.resignFirstResponder()
    }
    
    // MARK: - KeyBoard 활성화
    @objc func typeLabelClicked() {
        typeHiddenTextField.becomeFirstResponder()
    }
    
    @objc func inputMoneyClicked() {
        inputMoneyHiddenTextField.becomeFirstResponder()
    }
    
    lazy var outLineViewLeadingAnchor = outLineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    
    lazy var outLineViewTrailingAnchor = outLineView.trailingAnchor.constraint(equalTo: self.expendButton.trailingAnchor)

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
        view.addSubview(inputMoneyHiddenTextField)
        view.addSubview(separatorLine)
        view.addSubview(iconConstLabel)
        view.addSubview(iconCollectionView)
        
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
            
            // MARK: - typeHiddenTextField Layout
            typeHiddenTextField.centerXAnchor.constraint(equalTo: self.typeLabel.centerXAnchor),
            typeHiddenTextField.topAnchor.constraint(equalTo: self.typeLabel.topAnchor),
            
            // MARK: - inputMoneyLabel Layout
            inputMoneyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inputMoneyLabel.topAnchor.constraint(equalTo: self.typeLabel.bottomAnchor, constant: 15),
            
            // MARK: - inputMoneyHiddenTextField Layout
            inputMoneyHiddenTextField.centerXAnchor.constraint(equalTo: self.inputMoneyLabel.centerXAnchor),
            inputMoneyHiddenTextField.topAnchor.constraint(equalTo: self.inputMoneyLabel.topAnchor),

            // MARK: - separatorLine Layout
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: self.inputMoneyLabel.bottomAnchor, constant: 25),
            
            // MARK: - iconConstLabel Layout
            iconConstLabel.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: 10),
            iconConstLabel.leadingAnchor.constraint(equalTo: self.separatorLine.leadingAnchor, constant: 15),
            
            // MARK: - iconCollectionView Layout
            iconCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            iconCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            iconCollectionView.topAnchor.constraint(equalTo: self.iconConstLabel.bottomAnchor, constant: 10),
            iconCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    func setReactive() {
        // MARK: - Coordinator 패턴
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // TODO: - Save 되면서 데이터가 저장되고, 만약 조건이 부족하다면 조건을 알려주는 역할을 ViewModel에서 필요함.
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
            .map {
                guard let text = $0 else { return "" }
                return text.isEmpty ? "타입을 입력해주세요." : text
            }
            .bind(to: viewModel.stringTypeObserver)
            .disposed(by: disposeBag)
        
        // TODO: - text가 입력이 될 때 클리어하기
        typeHiddenTextField.rx.controlEvent(.editingDidBegin)
            .map { [weak self] _ in
                guard let self = self else { return "" }
                typeHiddenTextField.text = ""
                return ""
            }
            .bind(to: viewModel.stringTypeObserver)
            .disposed(by: disposeBag)
        
        typeHiddenTextField.rx.controlEvent(.editingDidEnd)
            .map { [weak self] _ in
                guard let self = self else { return "" }
                guard let text = typeHiddenTextField.text else { return "" }
                return text.isEmpty ? "타입을 입력해주세요." : text
            }.bind(to: viewModel.stringTypeObserver)
            .disposed(by: disposeBag)
        
        viewModel.stringTypeObservable
            .observe(on: MainScheduler.instance)
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - inputMoney 바인딩
        inputMoneyHiddenTextField.rx.text
            .observe(on: MainScheduler.instance)
            .map { $0 ?? "" }
            .bind(to: viewModel.inputMoneyObserver)
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
    }
}
