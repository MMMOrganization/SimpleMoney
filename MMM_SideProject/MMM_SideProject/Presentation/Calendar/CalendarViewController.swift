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

// CalendarVC 킬 때, 선택된 달의 지출 데이터 받아오기. (없으면 "-" 라고 표시)
// 클릭한 날짜의 전체 데이터 받아오기.

// 좌클릭, 우클릭 바인딩 하기 (달이 바뀐 것을 관찰하고 데이터 받아와야 함.)

class CalendarViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : CalendarViewModelInterface!
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
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
    
    // TODO: - SelectionStyle UI 변경 필요
    let calendarView : FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.weekdayHeight = 30 // 요일 글자와 날짜의 높이 차이
        calendar.appearance.weekdayFont = UIFont(name: FontConst.mainFont, size: 14)
        calendar.appearance.subtitleFont = UIFont(name: FontConst.mainFont, size: 10)
        calendar.appearance.headerTitleFont = UIFont(name: FontConst.mainFont, size: 14)
        calendar.appearance.titleTodayColor = .mainColor
        calendar.scope = .month
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.borderSelectionColor = .mainColor
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scope = .month
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 20
        calendar.headerHeight = 0
        calendar.layer.borderColor = UIColor.red.cgColor
        calendar.swipeToChooseGesture.isEnabled = false
        calendar.scrollEnabled = false
        calendar.backgroundColor = .white
        
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 2) // 서브타이틀 위치 조정
        calendar.appearance.subtitleDefaultColor = .gray // 기본 서브타이틀 색상
        calendar.appearance.subtitleSelectionColor = .blue // 선택됐을 때 서브타이틀 색상
        return calendar
    }()
    
    lazy var headerStack : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [previousButton, titleLabel, nextButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
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
        button.setImage(UIImage(named: "previous"), for: .normal)
        return button
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following"), for: .normal)
        return button
    }()
    
    private let today : Date = {
        return Date()
    }()
    
    let tableView : UITableView = {
        let tv = UITableView()
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
        tableView.rowHeight = 75
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
            
            // MARK: - previous, next Button Width Height
            previousButton.widthAnchor.constraint(equalToConstant: 17),
            previousButton.heightAnchor.constraint(equalToConstant: 17),
            
            nextButton.widthAnchor.constraint(equalToConstant: 17),
            nextButton.heightAnchor.constraint(equalToConstant: 17),
            
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
        
        // MARK: - Cell Data 바인딩
        // TODO: - Cell 크기 및 레이아웃 다시 조정 필요.
        // TODO: - cell.configure() 함수 리팩토링 필요.
        viewModel.dataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DetailTableViewCell.identifier, cellType: DetailTableViewCell.self)) { (index, item, cell) in
                cell.configure(item: item)
                cell.contentView.layer.cornerRadius = 15
                cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.05)
                //cell.contentView.layer.shadowColor = UIColor.mainColor.cgColor
                //cell.layer.shadowOpacity = 0.20
                //cell.layer.shadowRadius = 5
                //cell.layer.shadowOffset = CGSize(width: -2, height: 2)
                //cell.layer.masksToBounds = false
                //cell.clipsToBounds = true
        }.disposed(by: disposeBag)
        
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
      
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: amount))
    }
}

extension CalendarViewController {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            // 원하는 액션 추가
            success(true)
        }
        
        delete.backgroundColor = .white
        delete.image = UIImage(named: "addImage")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

