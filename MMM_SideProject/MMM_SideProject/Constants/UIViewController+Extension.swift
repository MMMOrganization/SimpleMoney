//
//  UIViewController+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/12/25.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { _ in }
      return ControlEvent(events: source)
    }
}
