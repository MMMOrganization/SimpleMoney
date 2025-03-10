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
    var entityData : Entity
    
    init(viewModel : DetailViewModelInterface, entityData : Entity) {
        self.viewModel = viewModel
        self.entityData = entityData
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setReactive()
    }
    
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
    
    func setReactive() {
        // MARK: - cancelButton 클릭 바인딩
        cancelButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }.disposed(by: disposeBag)
        
        // MARK: - deleteButton 클릭 바인딩
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }.disposed(by: disposeBag)
        
        // MARK: - deleteButton 클릭 바인딩 (Entity 제거)
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .map { [weak self] in
                guard let self = self else
                { return Entity(id: UUID(), dateStr: "", typeStr: "", createType: .total, amount: 0, iconImage: UIImage()) }
                ToastManager.shared.showToast(message: "삭제 완료되었습니다.")
                return entityData
            }
            .bind(to: viewModel.deleteDataObserver)
            .disposed(by: disposeBag)
    }
}
