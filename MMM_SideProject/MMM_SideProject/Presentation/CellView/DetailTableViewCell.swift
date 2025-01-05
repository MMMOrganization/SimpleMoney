//
//  DetailTableViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/23/24.
//

import UIKit

enum DetailCellStyle {
    case compact // 간격 X
    case spacious // 간격 O
}

class DetailTableViewCell: UITableViewCell {

    var cellStyle : DetailCellStyle = .compact
    
    static let identifier = "DetailCell"
    
    let imageBorderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: ColorConst.mainColorString).cgColor
        return view
    }()
    
    let mainImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "DateImage")
        return image
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "정기 결제"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch cellStyle {
        case .compact:
            contentView.frame = bounds
        case .spacious:
            contentView.frame = bounds.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0))
        }
        
        imageBorderView.layer.cornerRadius = imageBorderView.frame.height / 2
    }
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with style : DetailCellStyle) {
        self.cellStyle = style
        setNeedsLayout()
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
            
            mainImageView.widthAnchor.constraint(equalToConstant: 20),
            mainImageView.heightAnchor.constraint(equalToConstant: 20),
            mainImageView.centerXAnchor.constraint(equalTo: self.imageBorderView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.imageBorderView.centerYAnchor),
            
            mainLabel.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 15),
            mainLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            
            dateLabel.leadingAnchor.constraint(equalTo: self.mainLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3),
            
            moneyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            moneyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3)
        ])
    }
}
