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
    
    let hostingController = UIHostingController(rootView: CircleGraphView(entityData: iPhoneOperationSystem.dummyData()))
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var graphView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)

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
        setLayout()
        setReactive()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        
        addChild(hostingController)
        
        view.addSubview(graphView)
        graphView.addSubview(hostingController.view)
        hostingController.view.frame = graphView.frame
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            graphView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            graphView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            hostingController.view.centerYAnchor.constraint(equalTo: self.graphView.centerYAnchor),
            hostingController.view.centerXAnchor.constraint(equalTo: self.graphView.centerXAnchor),
        ])
    }
    
    func setReactive() {
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
    }
}
