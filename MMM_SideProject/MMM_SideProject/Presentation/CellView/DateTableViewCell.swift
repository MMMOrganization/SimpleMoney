//
//  DateTableViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class DateTableViewCell: UITableViewCell {
    
    static let identifier = "DateTVC"
    var disposeBag : DisposeBag = .init()

    let dateLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(size: 17.0)
        l.textColor = .blackColor
        return l
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLayout() {
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
        ])
    }
    
    func configure(dateStr : String) {
        dateLabel.text = dateStr
        contentView.backgroundColor = .white
        selectionStyle = .none
    }
    
    deinit {
        print("DateTableViewCell - 메모리 해제")
    }
}
