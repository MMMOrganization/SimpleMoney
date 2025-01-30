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

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var cancellables = Set<AnyCancellable>()
    
    var viewModel : GraphViewModelInterface!
    // MARK: - Graph 클릭 이벤트를 받기 위해서 사용되는 ViewModel
    var graphViewModel : GraphViewModelForSwiftUI!
    // 동일한 인스턴스를 전달하여 GraphViewController 와, CircleGraphView 가 모두 참조할 수 있도록 함.
    
    let tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)

    lazy var graphView : GraphView = {
        let view = GraphView(frame: CGRect(), viewModel: graphViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel : GraphViewModelInterface, graphViewModel : GraphViewModelForSwiftUI) {
        self.viewModel = viewModel
        self.graphViewModel = graphViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("GraphViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setLayout()
        setReactive()
        // Do any additional setup after loading the view.
    }
    
    func setTableView() {
        tableView.dataSource = nil
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        
        self.view.addSubview(graphView)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalToConstant: 300),
            graphView.heightAnchor.constraint(equalToConstant: 300),
            graphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.graphView.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setReactive() {
        //MARK: - Coordinator 화면 전환 바인딩
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - GraphViewModel의 Publisher와의 바인딩 (Combine)
        graphViewModel.$selectedStyle
            .sink { [weak self] expendCount in
                guard let self = self, let expendType = expendCount?.expendType else { return }
                self.viewModel.expendTypeObserver.onNext(expendType)
            }.store(in: &cancellables)
        
        // MARK: - Cell 바인딩 과정
        viewModel.dataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DetailTableViewCell.identifier, cellType: DetailTableViewCell.self)) { (index, item, cell) in
                cell.configure(item: item)
                cell.contentView.layer.cornerRadius = 15
                cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.05)
            }.disposed(by: disposeBag)
    }
}

// viewmodel anyobserver로 받고
// cell에 뿌려주고
// cell이 받으면 끗

