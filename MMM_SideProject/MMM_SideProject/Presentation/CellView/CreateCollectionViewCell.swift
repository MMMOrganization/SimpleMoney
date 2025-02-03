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
        self.iconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(item : CreateCellIcon) {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.backgroundColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 0.05)
                                                   
        self.iconImageView.image = item.iconImage
    }
    
    func setLayout() {
        self.contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
