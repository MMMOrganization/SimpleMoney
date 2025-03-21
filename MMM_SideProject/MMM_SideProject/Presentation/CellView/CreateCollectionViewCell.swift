//
//  CreateCollectionViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/9/25.
//

import UIKit

class CreateCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "CreateCell"
    
    lazy var iconImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(item : CreateCellIcon) {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .grayColor.withAlphaComponent(0.05)
        contentView.layer.borderWidth = 1
        
        contentView.layer.borderColor = item.getIsSelected() ? UIColor.mainColor.cgColor : UIColor.clear.cgColor
        iconImageView.image = item.getImageType().getImage.resize(targetSize: CGSize(width: contentView.frame.height / 2, height: contentView.frame.height / 2))
    }
    
    func setLayout() {
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    
    deinit {
        print("CreateCollectionViewCell - 메모리 해제")
    }
}
