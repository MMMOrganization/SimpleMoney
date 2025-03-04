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
import Combine
import DGCharts

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var cancellables = Set<AnyCancellable>()
    
    var viewModel : GraphViewModelInterface!
    
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
        c.layer.shouldRasterize = false
        return c
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonCollectionView.layer.addBorder([.bottom])
    }
    
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
        setDelegate()
        setLayout()
        setReactive()
    }
    
    func setDelegate() {
        pieChartView.delegate = self
        buttonCollectionView.delegate = self
        buttonCollectionView.dataSource = self
        
        buttonCollectionView.register(TypeButtonCVCell.self, forCellWithReuseIdentifier: TypeButtonCVCell.identifier)
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        
        self.view.addSubview(pieChartView)
        self.view.addSubview(buttonCollectionView)
        
        
        
        NSLayoutConstraint.activate([
            pieChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            pieChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            pieChartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pieChartView.heightAnchor.constraint(equalToConstant: 300),
            
            buttonCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            buttonCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            buttonCollectionView.topAnchor.constraint(equalTo: self.pieChartView.bottomAnchor),
            buttonCollectionView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    func setReactive() {
        //MARK: - Coordinator 화면 전환 바인딩
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        viewModel.graphDataObservable
            .subscribe { [weak self] eventDict in
                guard let eventDict = eventDict.element else { return }
                guard let self = self else { return }
                
                let sortedEventDict = eventDict.sorted {
                    $0.value > $1.value
                }
                
                var entriesDict = [String : Double]()
                
                sortedEventDict.forEach {
                    entriesDict[$0.key] = $0.value
                }
                
                setPieChart(entriesDict: entriesDict)
            }.disposed(by: disposeBag)
    }
}

// TODO: - 후에 RxSwift 로 바꿀 것.
extension GraphViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeButtonCVCell.identifier, for: indexPath) as? TypeButtonCVCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

// MARK: - ChartViewDelegate
extension GraphViewController : ChartViewDelegate {
    func setPieChart(entriesDict : [String : Double]) {
        // TODO: - ViewModel에서 각 지출 타입마다의 개수를 딕셔너리 형태로 보내줘야 함.
        // -> 일단 Mock 으로 클리어
        // TODO: - 받고 그래프를 그린다.
        // -> Mock 으로 클리어
        // TODO: - 지출 타입의 개수를 확인하고 매핑하여 CollectionView를 가진다.
        // TODO: - TableView 와 CollectionView를 매핑한다.
        
        var entryList : [PieChartDataEntry] = []
        
        // 받아온 딕셔너리를 entryList로 변환하는 과정
        entriesDict.forEach {
            entryList.append(PieChartDataEntry(value: $0.value, label: $0.key))
        }
        
        let dataSet = PieChartDataSet(entries: entryList, label: "")
        
        // 🎨 각 조각별 색상
        // TODO: - 개수에 맞춰서 어떻게 색상을 조절할 지 고민해봐야 함.
        dataSet.colors = [
            UIColor.red.withAlphaComponent(0.20),
            UIColor.orange.withAlphaComponent(0.25),
            UIColor.yellow.withAlphaComponent(0.30),
            UIColor.green.withAlphaComponent(0.35),
            UIColor.blue.withAlphaComponent(0.40),
        ]
        
        dataSet.sliceSpace = 5
        
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
