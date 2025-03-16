//
//  DetailViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/16/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class DetailViewController: UIViewController {
    
    private var disposeBag : DisposeBag = DisposeBag()
    private var viewModel : DetailViewModelInterface!
    
    // MARK: - Section 사용을 위한 TableView DataSource
    private let dataSource =
    RxTableViewSectionedAnimatedDataSource<SectionModel>(configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: .compact, item: item)
        return cell
    }) { dataSource, index in
        return dataSource.sectionModels[index].header
    }
    
    lazy var calendarBarButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dateImage")?.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var graphBarButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "barGraph")?.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    // MARK: - Navigation 관련 프로퍼티
    lazy var calendarBarButtonItem = UIBarButtonItem(customView : calendarBarButton)
    lazy var graphBarButtonItem = UIBarButtonItem(customView: graphBarButton)
    
    // MARK: - 애니메이션 관련 프로퍼티
    lazy var toastViewHeight : CGFloat = 150
    lazy var toastViewBottomAnchor = toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: toastViewHeight)
    
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
        label.text = "\(YearMonthDay().getMonth())월 통계"
        label.textAlignment = .right
        return label
    }()
    
    let topTotalPriceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 30)
        label.text = "+120,000원"
        label.textColor = .blackColor
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
        label.text = YearMonthDay().toStringYearMonth()
        label.font = UIFont(name: FontConst.mainFont, size: 15)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString, alpha: 1.00)
        return label
    }()
    
    lazy var topChangeLeftButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.blackColorString, alpha: 1.00)
        return button
    }()
    
    lazy var topChangeRightButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "following")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
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
        tv.backgroundColor = .systemGray4.withAlphaComponent(0.05)
        return tv
    }()
    
    lazy var contentAddButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addImage")?.resize(targetSize: CGSize(width: 60, height: 60)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - ToastView
    lazy var toastView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let toastMainLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "해당 데이터를 삭제할까요?"
        label.textColor = .blackColor
        label.font = UIFont(size: 14.0)
        return label
    }()
    
    lazy var toastButtonStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [toastCancelButton, toastDeleteButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 0
        sv.alignment = .fill
        return sv
    }()
    
    lazy var toastCancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(size: 14.0)
        button.setTitleColor(.blackColor, for: .normal)
        return button
    }()
    
    lazy var toastDeleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont(size: 14.0)
        button.setTitleColor(.blackColor, for: .normal)
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
        setGestures()
        setAnimate()
        setTableView()
        setReactive()
        setToastReactive()
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
    
    func setTableView() {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.dataSource = nil
        tableView.delegate = self
        tableView.rowHeight = 50
    }

    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = 
        navigationController?.navigationBar.standardAppearance
        navigationController?.isToolbarHidden = true
        navigationItem.rightBarButtonItem = calendarBarButtonItem
        navigationItem.leftBarButtonItem = graphBarButtonItem
        
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(buttonView)
        view.addSubview(separatorLine)
        view.addSubview(tableView)
        view.addSubview(contentAddButton)
        view.addSubview(toastView)
        
        topView.addSubview(topMonthLabel)
        topView.addSubview(topTotalPriceLabel)
        topView.addSubview(topChangeMonthView)
        
        topChangeMonthView.addSubview(topChangeLeftButton)
        topChangeMonthView.addSubview(topChangeMonthLabel)
        topChangeMonthView.addSubview(topChangeRightButton)
        
        buttonView.addSubview(totalShowButton)
        buttonView.addSubview(incomeShowButton)
        buttonView.addSubview(expendShowButton)
        
        toastView.addSubview(toastMainLabel)
        toastView.addSubview(toastButtonStackView)
        
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
            
            topChangeLeftButton.centerYAnchor.constraint(equalTo: self.topChangeMonthView.centerYAnchor),
            topChangeLeftButton.trailingAnchor.constraint(equalTo: self.topChangeMonthLabel.leadingAnchor, constant: -5),
            
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
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentAddButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            contentAddButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
        ])
        
        // MARK: - ToastView
        NSLayoutConstraint.activate([
            toastView.heightAnchor.constraint(equalToConstant: toastViewHeight),
            toastView.widthAnchor.constraint(equalToConstant: 300),
            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastViewBottomAnchor,
            
            toastMainLabel.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
            toastMainLabel.topAnchor.constraint(equalTo: self.toastView.topAnchor, constant: 55),
            
            toastButtonStackView.heightAnchor.constraint(equalToConstant: 50),
            toastButtonStackView.leadingAnchor.constraint(equalTo: self.toastView.leadingAnchor),
            toastButtonStackView.trailingAnchor.constraint(equalTo: self.toastView.trailingAnchor),
            toastButtonStackView.bottomAnchor.constraint(equalTo: self.toastView.bottomAnchor),
        ])
    }
    
    func setGestures() {
        let tapGesture = UITapGestureRecognizer()
        tableView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe { [weak self] gesture in
                guard let self = self, let gesture = gesture.element else {
                    print("DetailView - Gesture Subscribe Fail")
                    return }
                
                let touchPoint : CGPoint = gesture.location(in: self.tableView)
                guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
                    print("DetailView - Gesture IndexPath Fail")
                    return
                }
                
                guard let cell = tableView.cellForRow(at: indexPath) as? DetailTableViewCell else {
                    return
                }
                
                guard let entityData = cell.entityData else { return }
                
                viewModel.selectedCellObserver.onNext(entityData)
                becomeToastView()
            }.disposed(by: disposeBag)
    }
    
    func setAnimate() {
        dataSource.animationConfiguration = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .none,
            deleteAnimation: .fade
        )
    }
    
    func setReactive() {
        self.rx.viewWillAppear
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.viewWillAppearObserver)
            .disposed(by: disposeBag)

        graphBarButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.graphButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Coordinator 바인딩
        calendarBarButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dateButtonObserver)
            .disposed(by: disposeBag)
        
        contentAddButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.plusButtonObserver)
            .disposed(by: disposeBag)
    
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
        
        // MARK: - 전체 데이터 바인딩
        totalShowButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { ButtonType.total }
            .bind(to: viewModel.totalDataObserver)
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
            .map { .decrease }
            .bind(to: viewModel.dateDecreaseButtonObserver)
            .disposed(by: disposeBag)
        
        topChangeRightButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { .increase }
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
        
        // MARK: - Section 을 포함한 TableView 바인딩
        viewModel.sectionModelObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - 통계 라벨 바인딩
        viewModel.totalAmountObservable
            .observe(on: MainScheduler.instance)
            .bind(to: topTotalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - HeaderFooter Label 색 설정 -> 추후에 바인딩 방법으로 할 예정
extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .gray.withAlphaComponent(0.6)
        }
    }
}

// MARK: - Toast 관련 코드
extension DetailViewController {
    func becomeToastView() {
        // MARK: - 화면 정중앙에 애니메이션
        toastViewBottomAnchor.constant = -((view.frame.height / 2) - (toastViewHeight / 2))
        view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.1) { [weak self] in
//            guard let self = self else { return }
//            
//        }
    }
    
    func resignToastView() {
        toastViewBottomAnchor.constant = toastViewHeight
        view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.1) { [weak self] in
//            guard let self = self else { return }
//            
//        }
    }
    
    func setToastReactive() {
        // MARK: - cancelButton 클릭 바인딩
        toastCancelButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                resignToastView()
            }.disposed(by: disposeBag)
        
        // MARK: - deleteButton 클릭 바인딩 (Entity 제거)
        toastDeleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                resignToastView()
                viewModel.removeCellObserver.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
