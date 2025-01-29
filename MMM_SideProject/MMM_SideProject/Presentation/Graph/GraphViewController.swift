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

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : GraphViewModelInterface!
    // MARK: - Graph 클릭 이벤트를 받기 위해서 사용되는 ViewModel
    // 동일한 인스턴스를 전달하여 GraphViewController 와, CircleGraphView 가 모두 참조할 수 있도록 함.
    var graphViewModel : GraphViewModelForSwiftUI!
    
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
        setLayout()
        setReactive()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        
        self.view.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalToConstant: 300),
            graphView.heightAnchor.constraint(equalToConstant: 300),
            graphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    func setReactive() {
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
    }
}
