//
//  GraphViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit
import RxSwift
import RxCocoa

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : GraphViewModelInterface!
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
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
    }
    
    func setReactive() {
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
    }
}
