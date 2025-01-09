//
//  UIFont+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/6/25.
//

import UIKit

extension UIFont {
    /// mainFont 적용된 편의 생성자
    convenience init(size : CGFloat) {
        self.init(name: FontConst.mainFont, size: size)!
    }
}
