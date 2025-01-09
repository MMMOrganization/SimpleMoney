//
//  CALayer+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/5/25.
//

import UIKit

extension CALayer {
    // 테두리에 색 넣어주기.
    func addBorder(_ arr_edge : [UIRectEdge], color : UIColor = .mainColor, width : CGFloat = 1.0) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
                break
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: width)
                break
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
                break
            case .right:
                border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
