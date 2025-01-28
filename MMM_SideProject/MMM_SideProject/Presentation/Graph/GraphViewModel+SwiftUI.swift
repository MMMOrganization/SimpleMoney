//
//  GraphViewModel+SwiftUI.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/28/25.
//

import SwiftUI
import Charts
import Combine
import RxSwift
import RxCocoa

// Dummy 객체 (테스트용)
enum ExpendType : String {
    case date1 = "date1"
    case date2 = "date2"
    case date3 = "date3"
}

struct ExpendCount {
    let expendType : ExpendType
    let count : Int
}

class GraphViewModelForSwiftUI: ObservableObject {
    @Published var selectedData: Double?
    @Published var selectedType: ExpendType?
    @Published var isSelected: Bool = false
    
    // MARK: - 선택된 지출 타입을 퍼블리셔해서 추적을 통해 Cell을 변경해야 함.
    @Published var selectedStyle : ExpendCount?
    
    private var calcellables = Set<AnyCancellable>()
    
    private var repository : DataRepositoryInterface
    private let entityData : [ExpendCount]
    
    private let cumulativeSalesRanges: [(expendType: ExpendType, range: Range<Double>)]
    
    // TODO: - Observable로 데이터를 전달해야 함.
    //let cumulativeSalesRanges: [(version: String, range: Range<Double>)]
    
    init(repository : DataRepositoryInterface) {
        self.repository = repository
        
        self.entityData = [ExpendCount(expendType: .date1, count: 15),
                           ExpendCount(expendType: .date2, count: 17),
                           ExpendCount(expendType: .date3, count: 23)
                          ]
        
        var cumulative = 0.0
        self.cumulativeSalesRanges = entityData.map {
            let newCumulative = cumulative + Double($0.count)
            let result = (expendType: $0.expendType, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
        }
        
        Publishers.CombineLatest3($selectedData, $selectedType, $isSelected)
            .sink { [weak self] (selectedData, selectedType, isSelected) in
                self?.updateSelectedStyle(selectedData: selectedData, selectedType: selectedType, isSelected: isSelected)
            }.store(in: &calcellables)
    }
    
    private func updateSelectedStyle(selectedData: Double?, selectedType: ExpendType?, isSelected: Bool) {
            if let selectedType {
                selectedStyle = entityData.first { $0.expendType == selectedType }
            } else if !isSelected, let selectedData, let selectedIndex = cumulativeSalesRanges.firstIndex(where: {  $0.range.contains(selectedData) }) {
                selectedStyle = entityData[selectedIndex]
            } else {
                selectedStyle = nil
            }
        }
    
    func getEntityData() -> [ExpendCount] {
        return [ExpendCount(expendType: .date1, count: 15),
                ExpendCount(expendType: .date2, count: 17),
                ExpendCount(expendType: .date3, count: 23)]
    }
    
    func calculatePercentage(for style: ExpendCount) -> Int {
        let total = entityData.reduce(into: 0) { $0 += $1.count }
        return Int(Double(style.count) / Double(total) * 100)
    }
    
    func handleSelection() {
        if let selectedData,
           let selectedIndex = cumulativeSalesRanges
            .firstIndex(where: { $0.range.contains(selectedData) }) {
            let expendType = entityData[selectedIndex].expendType
            if selectedType == expendType {
                // If tapping the same section, deselect it
                selectedType = nil
                isSelected = false
            } else {
                // If tapping a different section, select it
                selectedType = expendType
                isSelected = true
            }
        }
    }
}

// TODO: - 현재 월 기준으로 Entity를 받아와서 뿌려줘야 함. (지출 타입을 통해서)
// TODO: - Entity를 받았을 때 지출, 수입 기준으로 나누고 화면이 나타날 땐 지출이 우선적으로 찍혀야 함.
// TODO: - 지출 타입별로 카운트를 알아야 비율을 계산할 수 있음.
// TODO: - 해당 Entity를 받으면 Cell을 통해서 또 뿌려줘야 함.

