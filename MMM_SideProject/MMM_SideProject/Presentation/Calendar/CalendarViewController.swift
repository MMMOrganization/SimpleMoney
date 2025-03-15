//
//  CalendarViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/1/25.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import RxDataSources

class CalendarViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : CalendarViewModelInterface!
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SingleSectionModel>(configureCell: { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: item)
        cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.05)
        return cell
    })
    
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftImage")?.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)
    
    let topView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        //view.layer.borderWidth = 1
        //view.layer.borderColor = UIColor.mainColor.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    let calendarView : FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - 요일 글자와 날짜의 높이 차이
        calendar.weekdayHeight = 30
        
        // MARK: - 현재 Custom Header와 제스쳐가 바인딩 되어 있지 않음.
        calendar.swipeToChooseGesture.isEnabled = false
        calendar.scrollEnabled = false
        
        // MARK: - Font 적용
        calendar.appearance.weekdayFont = UIFont(size: 14.0)
        calendar.appearance.subtitleFont = UIFont(size: 9.0)
        calendar.appearance.headerTitleFont = UIFont(size: 14)
        
        calendar.scope = .month
        // MARK: - Header제거 (Custom Header 사용)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 0
        
        // MARK: - 한국 시간 사용
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 20
        
        // MARK: - 오늘 날짜 색 세팅
        calendar.appearance.todayColor = .red.withAlphaComponent(0.05)
        calendar.appearance.titleTodayColor = .blackColor
        calendar.appearance.subtitleTodayColor = .gray
        
        // MARK: - 선택됐을 때 색 세팅
        calendar.appearance.titleSelectionColor = .blackColor
        calendar.appearance.selectionColor = .mainColor.withAlphaComponent(0.10)
        
        // MARK: - 서브타이틀 위치 조정
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 2)
        
        // MARK: - 기본 서브타이틀 색, 선택됐을 때 색
        calendar.appearance.subtitleDefaultColor = .gray
        calendar.appearance.subtitleSelectionColor = .blue
        
        return calendar
    }()
    
    lazy var headerStack : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [previousButton, titleLabel, nextButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.alignment = .fill
        sv.axis = .horizontal
        return sv
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: FontConst.mainFont, size: 13)
        return label
    }()
    
    lazy var previousButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        return button
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following")?.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        return button
    }()
    
    private let today : Date = {
        return Date()
    }()
    
    let tableView : UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    init(viewModel: CalendarViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("CalendarViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendar()
        setLayout()
        setTableView()
        setReactive()
    }
    
    func setTableView() {
        tableView.dataSource = nil
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 65
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        //updateHeaderTitle()
    }
    
    func setLayout() {
        navigationItem.leftBarButtonItem = dismissButtonItem
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(headerStack)
        topView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            // MARK: - headerStack Layout
            headerStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            headerStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            // MARK: - calenderView Layout
            calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            calendarView.topAnchor.constraint(equalTo: self.headerStack.bottomAnchor, constant: 5),
            calendarView.heightAnchor.constraint(equalToConstant: 250),
            
            // MARK: - topView Layout
            topView.topAnchor.constraint(equalTo: self.headerStack.topAnchor, constant: -10),
            topView.leadingAnchor.constraint(equalTo: self.calendarView.leadingAnchor, constant: -10),
            topView.trailingAnchor.constraint(equalTo: self.calendarView.trailingAnchor, constant: 10),
            topView.bottomAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 10),
            
            // MARK: - tableView Layout
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setReactive() {
        // MARK: - Coordinator 바인딩
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - headerTitle UI 바인딩
        previousButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { DateButtonType.decrease }
            .bind(to: viewModel.decreaseObserver)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { DateButtonType.increase }
            .bind(to: viewModel.increaseObserver)
            .disposed(by: disposeBag)
        
        viewModel.dateObservable
            .observe(on: MainScheduler.instance)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - headerTitle 변경 시에 Calendar 바인딩
        viewModel.dateButtonTypeObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] dateButtonType in
                guard let dateButtonType = dateButtonType.element, let self = self else { return }
                
                let currentMonth = calendarView.currentPage
                let month = Calendar.current.date(byAdding: .month, value: dateButtonType.rawValue, to: currentMonth)!
                calendarView.setCurrentPage(month, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.dataObservable
            .observe(on: MainScheduler.instance)
            .map { [SingleSectionModel(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - Calendar DayOfMonth Amount 바인딩
        viewModel.dailyAmountsObservable
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.calendarView.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension CalendarViewController : FSCalendarDataSource, FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {}
    
    // Calendar 날자 클릭시에 작동하는 delegate 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.dayOfMonthClickObserver.onNext(date.getDay)
    }
    
    // 날짜에 Subtitle 넣는 delegate 메소드
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard let amount = viewModel.getAmountForDay(date) else { return "-" }
        
        return amount.toCurrency.replacingOccurrences(of: "원", with: "")
    }
}

