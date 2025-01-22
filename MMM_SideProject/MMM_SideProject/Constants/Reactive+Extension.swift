//
//  Reactive+Extension.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/21/25.
//

import UIKit
import RxCocoa
import RxSwift
import FSCalendar

/// 어떤 뜻일까?
extension Reactive where Base : FSCalendar {
    var didSelectData : Observable<Int> {
        return methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .map { parameters in
                let tempDate = parameters[1] as? Date ?? Date()
                return tempDate.getDay
            }
    }
}
