//
//  UIView+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/12/24.
//

import UIKit

extension UIView {
    // MARK: - TableView에 데이터가 없을 경우 대체할 View
    static func getEmptyView(width : CGFloat, height : CGFloat) -> UIView {
        let emptyView : UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            return v
        }()
        
        let emptyLabel : UILabel = {
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            l.text = "데이터가 없습니다."
            l.textColor = .grayColor
            l.font = UIFont(size: 17.0)
            l.textAlignment = .center
            return l
        }()
        
        emptyView.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
        ])
        
        return emptyView
    }
    
    func roundCorners(cornerRadius : CGFloat, maskedCorners : CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
