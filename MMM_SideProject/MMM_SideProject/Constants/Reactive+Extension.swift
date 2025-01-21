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
    var currentPage : Observable<Date> {
        return methodInvoked(#selector(FSCalendarDelegate.calendarCurrentPageDidChange(_:)))
            .map { _ in self.base.currentPage }
            .startWith(base.currentPage)
    }
}
