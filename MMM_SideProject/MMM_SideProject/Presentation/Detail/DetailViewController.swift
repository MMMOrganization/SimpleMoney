//
//  DetailViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/16/24.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {
    
    let dataList : [Int] = [3, 5, 4]
    var disposeBag : DisposeBag = DisposeBag()
    
    var viewModel : DetailViewModelInterface!
    
    lazy var calendarBarButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(named: "DateImage2"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var barButtonItem = UIBarButtonItem(customView : calendarBarButton)
    
    let topView : UIView = {
        // 160 height
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.08)
        return view
    }()
    
    let topMonthLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 16)
        label.textColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 1.00)
        label.text = "\(YearMonth().month)월 통계"
        label.textAlignment = .right
        return label
    }()
    
    let topTotalPriceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 30)
        label.text = "+120,000원"
        label.textAlignment = .right
        return label
    }()
    
    let topChangeMonthView : UIView = {
        // 25 height
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(
            cornerRadius: 20,
            maskedCorners: CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        )
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        return view
    }()
    
    let topChangeMonthLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = YearMonth().toString()
        label.font = UIFont(name: FontConst.mainFont, size: 15)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString, alpha: 1.00)
        return label
    }()
    
    lazy var topChangeLeftButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.blackColorString, alpha: 1.00)
        return button
    }()
    
    lazy var topChangeRightButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "following"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(hexCode: ColorConst.blackColorString, alpha: 1.00)
        return button
    }()
    
    let buttonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var showButtons : [UIButton] = [totalShowButton, incomeShowButton, expendShowButton]
    
    let totalShowButton : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체", for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: FontConst.mainFont, size: 14)
        button.setTitleColor(UIColor(hexCode: ColorConst.blackColorString), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        button.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.15)
        return button
    }()
    
    let incomeShowButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("수입", for: .normal)
        button.titleLabel?.font = UIFont(name: FontConst.mainFont, size: 14)
        button.setTitleColor(UIColor(hexCode: ColorConst.blackColorString), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        return button
    }()
    
    let expendShowButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("지출", for: .normal)
        button.titleLabel?.font = UIFont(name: FontConst.mainFont, size: 14)
        button.setTitleColor(UIColor(hexCode: ColorConst.blackColorString), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        return button
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.20)
        return view
    }()
    
    var tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var contentAddButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addImage"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Initializer
    init(viewModel : DetailViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("DetailViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTableView()
        setReactive()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        contentAddButton.layer.cornerRadius = contentAddButton.frame.width / 2
        
        totalShowButton.layer.cornerRadius = totalShowButton.frame.height / 2
        incomeShowButton.layer.cornerRadius = incomeShowButton.frame.height / 2
        expendShowButton.layer.cornerRadius = expendShowButton.frame.height / 2
    }
    
    // MARK: - ViewModel이 해야할 일임. (MVVM 형태로 바꿀 때 변화 필요)
    
    func setTableView() {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.dataSource = nil
        tableView.rowHeight = 50
    }
    
    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = 
        navigationController?.navigationBar.standardAppearance
        navigationItem.rightBarButtonItem = barButtonItem
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(buttonView)
        view.addSubview(separatorLine)
        view.addSubview(tableView)
        view.addSubview(contentAddButton)
        
        topView.addSubview(topMonthLabel)
        topView.addSubview(topTotalPriceLabel)
        topView.addSubview(topChangeMonthView)
        
        topChangeMonthView.addSubview(topChangeLeftButton)
        topChangeMonthView.addSubview(topChangeMonthLabel)
        topChangeMonthView.addSubview(topChangeRightButton)
        
        buttonView.addSubview(totalShowButton)
        buttonView.addSubview(incomeShowButton)
        buttonView.addSubview(expendShowButton)
        
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 160),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            
            topMonthLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 155),
            topMonthLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            topTotalPriceLabel.topAnchor.constraint(equalTo: self.topMonthLabel.bottomAnchor, constant: 5),
            topTotalPriceLabel.trailingAnchor.constraint(equalTo: self.topMonthLabel.trailingAnchor),
            
            topChangeMonthView.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 24),
            topChangeMonthView.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -24),
            topChangeMonthView.heightAnchor.constraint(equalToConstant: 25),
            topChangeMonthView.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            
            topChangeMonthLabel.centerXAnchor.constraint(equalTo: self.topChangeMonthView.centerXAnchor),
            topChangeMonthLabel.centerYAnchor.constraint(equalTo: self.topChangeMonthView.centerYAnchor),
            
            topChangeLeftButton.widthAnchor.constraint(equalToConstant: 17),
            topChangeLeftButton.heightAnchor.constraint(equalToConstant: 17),
            topChangeLeftButton.centerYAnchor.constraint(equalTo: self.topChangeMonthView.centerYAnchor),
            topChangeLeftButton.trailingAnchor.constraint(equalTo: self.topChangeMonthLabel.leadingAnchor, constant: -5),

            topChangeRightButton.widthAnchor.constraint(equalToConstant: 17),
            topChangeRightButton.heightAnchor.constraint(equalToConstant: 17),
            topChangeRightButton.centerYAnchor.constraint(equalTo: self.topChangeMonthView.centerYAnchor),
            topChangeRightButton.leadingAnchor.constraint(equalTo: self.topChangeMonthLabel.trailingAnchor, constant: 5),
            
            buttonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: self.topChangeMonthView.bottomAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 50),
            
            totalShowButton.widthAnchor.constraint(equalToConstant: 54),
            totalShowButton.heightAnchor.constraint(equalToConstant: 29),
            totalShowButton.centerYAnchor.constraint(equalTo: self.buttonView.centerYAnchor),
            totalShowButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            
            incomeShowButton.widthAnchor.constraint(equalToConstant: 54),
            incomeShowButton.heightAnchor.constraint(equalToConstant: 29),
            incomeShowButton.centerYAnchor.constraint(equalTo: self.buttonView.centerYAnchor),
            incomeShowButton.leadingAnchor.constraint(equalTo: self.totalShowButton.trailingAnchor, constant: 5),
            
            expendShowButton.widthAnchor.constraint(equalToConstant: 54),
            expendShowButton.heightAnchor.constraint(equalToConstant: 29),
            expendShowButton.centerYAnchor.constraint(equalTo: self.buttonView.centerYAnchor),
            expendShowButton.leadingAnchor.constraint(equalTo: self.incomeShowButton.trailingAnchor, constant: 5),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: self.buttonView.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentAddButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            contentAddButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            contentAddButton.widthAnchor.constraint(equalToConstant: 60),
            contentAddButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setReactive() {
        // MARK: - 네비게이션 캘린더 버튼 바인딩
        calendarBarButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dateButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - contentAdd 버튼 바인딩
        contentAddButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.plusButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - 전체 데이터 바인딩
        let viewDidLoadObservable = rx.methodInvoked(#selector(self.viewDidLoad))
            .map { _ in }
        
        let totalButtonObservable = totalShowButton.rx.tap.asObservable()
            .map { _ in }
        
        [viewDidLoadObservable, totalButtonObservable]
            .forEach { $0.observe(on: MainScheduler.instance)
            .map { ButtonType.total }
            .bind(to: viewModel.totalDataObserver)
            .disposed(by: disposeBag) }
        
        // MARK: - 수입 데이터 바인딩
        incomeShowButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { ButtonType.income }
            .bind(to: viewModel.incomeDataObserver)
            .disposed(by: disposeBag)
        
        // MARK: - 지출 데이터 바인딩
        expendShowButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { ButtonType.expend }
            .bind(to: viewModel.expendDataObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Button Color 바인딩
        viewModel.selectedButtonIndexObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] selectedIndex in
                guard let selectedIndex = selectedIndex.element, let self = self else { return }
                showButtons.forEach { $0.backgroundColor = .white }
                showButtons[selectedIndex].backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
            }.disposed(by: disposeBag)
        
        // MARK: - DateLabel 바인딩
        topChangeLeftButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dateDecreaseButtonObserver)
            .disposed(by: disposeBag)
        
        topChangeRightButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dateIncreaseButtonObserver)
            .disposed(by: disposeBag)
        
        viewModel.dateObservable
            .observe(on: MainScheduler.instance)
            .bind(to: topChangeMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.monthObservable
            .observe(on: MainScheduler.instance)
            .bind(to: topMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - Cell 바인딩
        viewModel.entityObservable.bind(to: tableView.rx.items(cellIdentifier: DetailTableViewCell.identifier, cellType: DetailTableViewCell.self)) { (index, item, cell) in
            print(item)
        }.disposed(by: disposeBag)
    }
}

extension DetailViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataList[section]
//    }
//    
//    // Section 의 제목 반환
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "12/20"
//    }
//    
//    // Section의 개수를 반환
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
}
