//
//  DetailTableViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/23/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    static let identifier = "DetailCell"
    
    let imageBorderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        return view
    }()
    
    let mainImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        image.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        return image
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "정기 결제"
        label.font = UIFont(name: FontConst.mainFont, size: 16)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 12)
        label.textColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 0.90)
        label.text = "2024-10-21"
        return label
    }()
    
    let moneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "-12,000원"
        label.font = UIFont(name: FontConst.mainFont, size: 18)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        print(imageBorderView.frame.width / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        contentView.addSubview(imageBorderView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moneyLabel)
        
        imageBorderView.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            imageBorderView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            imageBorderView.widthAnchor.constraint(equalToConstant: 30),
            imageBorderView.heightAnchor.constraint(equalToConstant: 30),
            imageBorderView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            mainImageView.widthAnchor.constraint(equalToConstant: 14),
            mainImageView.heightAnchor.constraint(equalToConstant: 14),
            mainImageView.centerXAnchor.constraint(equalTo: self.imageBorderView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.imageBorderView.centerYAnchor),
            
            mainLabel.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 15),
            mainLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            dateLabel.leadingAnchor.constraint(equalTo: self.mainLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            moneyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            moneyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
