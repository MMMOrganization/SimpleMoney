//
//  TypeButtonCVCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/4/25.
//

import UIKit

class TypeButtonCVCell: UICollectionViewCell {
    
    static let identifier = "TypeCell"
    
    let typeButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blackColor, for: .normal)
        b.titleLabel?.font = UIFont(size: 14)
        b.clipsToBounds = true
        b.layer.borderWidth = 2
        // TODO: - 왜 프레임이 나오지 않을까?
        b.layer.cornerRadius = 14.5
        b.layer.borderColor = UIColor.mainColor.cgColor
        b.setTitle("타입", for: .normal)
        return b
    }()
    
    func configure(item: (String, UIColor)) {
        typeButton.setTitle(item.0, for: .normal)
        typeButton.layer.borderColor = item.1.cgColor
        typeButton.backgroundColor = item.1.withAlphaComponent(0.1)
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
