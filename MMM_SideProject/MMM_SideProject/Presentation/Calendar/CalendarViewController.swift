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
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: FontConst.mainFont, size: 13)
        return label
    }()
    
    lazy var previousButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous"), for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following"), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        updateHeaderTitle()
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
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
    }
    
    @objc func previousButtonTapped() {
        let currentMonth = calendarView.currentPage
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
        calendarView.setCurrentPage(previousMonth, animated: true)
        updateHeaderTitle() // 헤더 타이틀 업데이트
    }
    
    @objc func nextButtonTapped() {
        let currentMonth = calendarView.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
        calendarView.setCurrentPage(nextMonth, animated: true)
        updateHeaderTitle() // 헤더 타이틀 업데이트
    }
    
    func updateHeaderTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        self.titleLabel.text = formatter.string(from: calendarView.currentPage)
    }
}

extension CalendarViewController : FSCalendarDataSource, FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderTitle()
    }
    
    // 날짜에 subTitle 넣을 수 있음.
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        // 여기서 원하는 날짜에 텍스트 추가
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        // 예시: 특정 날짜에 텍스트 추가
        switch dateFormatter.string(from: date) {
        case "01-01":
            return ""
        case "12-25":
            return "크리스마스"
        default:
            return ""
        }
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        
        cell.selectionStyle = .none
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 0.8
        cell.dateLabel.text = "" // Calendar에서 보여주기 때문에 필요없음. (나중에 추가예정)
        cell.contentView.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.80).cgColor
        cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.02)
        
        // 그림자 추가
        //cell.configure(with: .spacious)
        
        return cell
    }
    
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

