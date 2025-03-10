//
//  DeleteToast.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class DeleteToastView : UIViewController {
    var viewModel : DetailViewModelInterface!
    var disposeBag : DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    init(viewModel : DetailViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tempView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "해당 데이터를 삭제할까요?"
        label.font = UIFont(size: 14.0)
        return label
    }()
    
    lazy var buttonStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 0
        sv.alignment = .fill
        return sv
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(size: 14.0)
        button.setTitleColor(.blackColor, for: .normal)
        return button
    }()
    
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont(size: 14.0)
        button.setTitleColor(.blackColor, for: .normal)
        return button
    }()
    
    func setLayout() {
        self.view.addSubview(tempView)
        
        tempView.addSubview(mainLabel)
        tempView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            tempView.heightAnchor.constraint(equalToConstant: 150),
            tempView.widthAnchor.constraint(equalToConstant: 300),
            tempView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tempView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            mainLabel.centerXAnchor.constraint(equalTo: tempView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: self.tempView.topAnchor, constant: 55),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: self.tempView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: self.tempView.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: self.tempView.bottomAnchor),
        ])
    }
}
