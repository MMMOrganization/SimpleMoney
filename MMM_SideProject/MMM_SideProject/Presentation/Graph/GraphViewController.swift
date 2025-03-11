//
//  GraphViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI
import RxDataSources
import DGCharts

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : GraphViewModelInterface!
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SingleSectionModel>(configureCell: { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: item)
        cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.05)
        return cell
    })
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)
    
    let pieChartView : PieChartView = {
        let p = PieChartView(frame: .zero)
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    let buttonCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 60, height: 40)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let c = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.showsHorizontalScrollIndicator = false
        return c
    }()
    
    lazy var headerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    
    let tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let navigationTitleButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blackColor, for: .normal)
        b.titleLabel?.font = UIFont(size: 14.0)
        return b
    }()
    
    init(viewModel : GraphViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("GraphViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setDelegate()
        setLayout()
        setReactive()
    }
    
    func setNavigationController() {
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        self.navigationItem.titleView = navigationTitleButton
    }
    
    func setDelegate() {
        pieChartView.delegate = self
        
        buttonCollectionView.dataSource = nil
        tableView.dataSource = nil
        
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        
        buttonCollectionView.register(TypeButtonCVCell.self, forCellWithReuseIdentifier: TypeButtonCVCell.identifier)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        headerView.addSubview(pieChartView)
        self.view.addSubview(buttonCollectionView)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            buttonCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buttonCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            buttonCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            pieChartView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            pieChartView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300),
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            tableView.topAnchor.constraint(equalTo: self.buttonCollectionView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        tableView.tableHeaderView = headerView
    }
    
    
    func setReactive() {
        // MARK: - Coordinator 화면 전환 바인딩
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Entity TableView 바인딩
        viewModel.entityDataObservable
            .observe(on: MainScheduler.instance)
            .map { [SingleSectionModel(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - Button 타입 라벨 바인딩
        viewModel.typeButtonDataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: buttonCollectionView.rx.items(cellIdentifier: TypeButtonCVCell.identifier, cellType: TypeButtonCVCell.self)) { [weak self] (index, item, cell) in
                guard let self = self else { return }
                cell.configure(item: item, viewModel : viewModel)
                // TODO: - button Click 스트림 걸어줘야 함.
        }.disposed(by: disposeBag)
        
        // MARK: - graphData 바인딩
        viewModel.graphDataObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] eventList in
                guard let eventList = eventList.element else { return }
                guard let self = self else { return }
                setPieChart(eventList: eventList)
            }.disposed(by: disposeBag)
        
        viewModel.dateObservable
            .observe(on: MainScheduler.instance)
            .bind(to: navigationTitleButton.rx.title())
            .disposed(by: disposeBag)
        
        navigationTitleButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let toastVC = graphDateToastView(viewModel: viewModel)
                addChild(toastVC)
                view.addSubview(toastVC.view)
                toastVC.didMove(toParent: self)
            }.disposed(by: disposeBag)
    }
}

// MARK: - ChartViewDelegate
extension GraphViewController : ChartViewDelegate {
    func setPieChart(eventList : [(String, Double)]) {
        // TODO: - CollectionView Element 클릭 요소에 매핑해야 함.
        /// Example.
        // TODO: - COllectionView 음주 클릭.
        // TODO: - 음주라는 Category 를 ViewModel에서 받음
        // TODO: - ViewModel에서 옵저버를 통해서 TableView 스트림에 날림.
        
        var entryList : [PieChartDataEntry] = []
        
        // 받아온 딕셔너리를 entryList로 변환하는 과정
        eventList.forEach {
            entryList.append(PieChartDataEntry(value: $0.1, label: $0.0))
        }
        
        let dataSet = PieChartDataSet(entries: entryList, label: "")
        
        // 🎨 각 조각별 색상
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.colors = dataSet.colors.map { $0.withAlphaComponent(0.4) }
        dataSet.sliceSpace = 5
        
        var buttonDataList = [(String, UIColor)]()
        
        // MARK: - typeButtonData 스트림을 던져줌.
        // TODO: - 색 로직 변경해야 함.
        for i in 0..<eventList.count {
            buttonDataList.append((eventList[i].0, dataSet.colors.randomElement() ?? .mainColor))
        }
        
        viewModel.typeButtonDataObserver.onNext(buttonDataList)
        
        // 🥯 도넛 형태 만들기 (원형 비율 조정)
        pieChartView.holeRadiusPercent = 0.25  // 중앙 구멍 크기
        pieChartView.transparentCircleRadiusPercent = 0.65  // 반투명한 원 크기
        
        // 구멍 근처에 있는 흰색 없애기
        pieChartView.transparentCircleColor = .clear
        
        // 🏷️ 라벨 위치 설정 (도넛 차트에 적합하게)
        dataSet.xValuePosition = .insideSlice  // 라벨을 내부에 표시
        dataSet.yValuePosition = .insideSlice  // 값도 내부에 표시
        
        // 클릭시에 효과 제거
        dataSet.selectionShift = 0
        
        // 라벨 스타일
        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        // 라벨 색상
        data.setValueTextColor(.blackColor.withAlphaComponent(0.7))
        data.setValueFont(UIFont(size: 16.0)) // 라벨 폰트
        
        pieChartView.data = data
        
        // 기타 설정
        pieChartView.legend.enabled = false  // 범례 숨기기
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)  // 애니메이션 효과
    }
}
