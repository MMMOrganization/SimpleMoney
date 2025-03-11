//
//  TypeButtonCVCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa

class TypeButtonCVCell: UICollectionViewCell {
    
    static let identifier = "TypeCell"
    
    var disposeBag : DisposeBag = .init()
    
    lazy var typeButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blackColor, for: .normal)
        b.titleLabel?.font = UIFont(size: 14)
        b.clipsToBounds = true
        b.layer.borderWidth = 2
        b.layer.cornerRadius = 14.5
        b.layer.borderColor = UIColor.mainColor.cgColor
        b.setTitle("타입", for: .normal)
        return b
    }()
    
    func configure(item: (String, UIColor), viewModel : GraphViewModelInterface) {
        disposeBag = .init()
        
        typeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                guard let typeName = typeButton.titleLabel?.text else { return }
                viewModel.typeButtonTapObserver.onNext(item.0)
            }.disposed(by: disposeBag)
        
        typeButton.setTitle(item.0, for: .normal)
        typeButton.layer.borderColor = item.1.cgColor
        typeButton.backgroundColor = item.1.withAlphaComponent(0.1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubview(typeButton)
        
        NSLayoutConstraint.activate([
            typeButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            typeButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            typeButton.widthAnchor.constraint(equalToConstant: 54),
            typeButton.heightAnchor.constraint(equalToConstant: 29)
        ])
    }
}
