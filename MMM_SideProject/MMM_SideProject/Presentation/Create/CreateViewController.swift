//
//  CreateViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/28/24.
//

import UIKit
import RxSwift
import RxCocoa

// AnyObject 를 사용하여 Class만을 강제해서, weak의 사용이 가능해짐.

class ToastView : UIViewController {
    
    // TODO: - ViewModel을 받아서 DatePicker가 변경될 때마다 Date를 전달할 수 있도록 하자.
    var viewModel : CreateViewModelInterface!
    var disposeBag : DisposeBag = .init()
    
    init(viewModel: CreateViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("CreateViewController ToastView - Initializer 에러")
    }
    
    lazy var tempView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainColor.cgColor
        return view
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko_KR")
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setLayout()
        setReactive()
    }
    
    func setLayout() {
        view.addSubview(tempView)
        tempView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            tempView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            tempView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 600),
            tempView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            datePicker.centerXAnchor.constraint(equalTo: self.tempView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: self.tempView.centerYAnchor)
        ])
    }
    
    func setReactive() {
        // MARK: - Date를 설정할 때마다 Date를 추적하는 스트림
        datePicker.rx.date
            .observe(on: MainScheduler.instance)
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: $0)
                return formattedDate.replacingOccurrences(of: "-", with: ".")
            }
            .bind(to: viewModel.stringDateObserver)
            .disposed(by: disposeBag)
    }
}

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
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
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
    
    lazy var dateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2024.12.04. 월요일", for: .normal)
        button.setBackgroundColor(UIColor(hexCode: ColorConst.mainColorString, alpha: 0.20), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(buttontapped), for: .touchUpInside)
        button.setTitleColor(.blackColor, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let expendTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "기타"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .grayColor
        return label
    }()
    
    let inputMoneyTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "120,000원"
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.font = UIFont(size: 35)
        tf.textColor = .blackColor
        tf.tintColor = .clear
        // 키보드 올라오게 해야 함.
        // 커서 땠을 때 원 표시되어야 함.
        // , 적용되어야 함.
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
        setReactive()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dateButton.layer.cornerRadius = dateButton.frame.height / 2
        expendButton.layer.addBorder([.bottom])
    }
    
    func setCollectionView() {
        iconCollectionView.dataSource = nil
        
        iconCollectionView.register(CreateCollectionViewCell.self, forCellWithReuseIdentifier: CreateCollectionViewCell.identifier)
    }
    
    @objc func buttontapped() {
        let dateVC = ToastView(viewModel: viewModel)
        addChild(dateVC)
        view.addSubview(dateVC.view)
        dateVC.didMove(toParent: self)
        
        dateVC.view.frame = view.bounds
    }

    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        navigationItem.leftBarButtonItem = dismissButtonItem
        view.backgroundColor = .white
        
        view.addSubview(topStackView)
        view.addSubview(dateButton)
        view.addSubview(expendTypeLabel)
        view.addSubview(inputMoneyTextField)
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
            
            // MARK: - dateButton Layout
            dateButton.topAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: 15),
            dateButton.widthAnchor.constraint(equalToConstant: 200),
            dateButton.heightAnchor.constraint(equalToConstant: 30),
            dateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - expendTypeLabel Layout
            expendTypeLabel.topAnchor.constraint(equalTo: self.dateButton.bottomAnchor, constant: 15),
            expendTypeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - inputMoneyTextField Layout
            inputMoneyTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inputMoneyTextField.topAnchor.constraint(equalTo: self.expendTypeLabel.bottomAnchor, constant: 15),
            
            // MARK: - separatorLine Layout
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: self.inputMoneyTextField.bottomAnchor, constant: 25),
            
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
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
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
        
        viewModel.dataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: iconCollectionView.rx.items(cellIdentifier: CreateCollectionViewCell.identifier, cellType: CreateCollectionViewCell.self)) { (index, item, cell) in
                cell.configure(item : item)
            }.disposed(by: disposeBag)
        
        // TODO: - DateButton 눌렀을 때 날짜 설정할 수 있도록.
        // TODO: - ToolBar를 사용하여 날짜를 조절할 수 있도록.
    }
}
