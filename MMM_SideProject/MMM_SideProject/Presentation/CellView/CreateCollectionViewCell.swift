//
//  CreateCollectionViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/9/25.
//

import UIKit

class CreateCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "CreateCell"
    
    let iconImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "addImage")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
