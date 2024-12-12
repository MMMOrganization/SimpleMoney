//
//  UIView+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/12/24.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius : CGFloat, maskedCorners : CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
