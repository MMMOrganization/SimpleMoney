//
//  GraphViewModel+SwiftUI.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/28/25.
//

import SwiftUI
import Charts

class GraphViewModelForSwiftUI: ObservableObject {
    @Published var selectedData: Double?
    @Published var selectedVersion: String?
    @Published var isSelected: Bool = false
    
    let entityData: [iPhoneOperationSystem]
    let cumulativeSalesRanges: [(version: String, range: Range<Double>)]
    
    init(entityData: [iPhoneOperationSystem] = iPhoneOperationSystem.dummyData()) {
        self.entityData = entityData
        
        var cumulative = 0.0
        self.cumulativeSalesRanges = entityData.map {
            let newCumulative = cumulative + Double($0.count)
            let result = (version: $0.version, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
        }
    }
    
    // MARK: - 선택된 그래프 비율을 통해 확인
    var selectedStyle: iPhoneOperationSystem? {
        if let selectedVersion {
            return entityData.first { $0.version == selectedVersion }
        } else if !isSelected, let selectedData,
                  let selectedIndex = cumulativeSalesRanges
            .firstIndex(where: { $0.range.contains(selectedData) }) {
            return entityData[selectedIndex]
        }
        return nil
    }
    
    // MARK: - Percentage 반환
    func calculatePercentage(for style: iPhoneOperationSystem) -> Int {
        let total = entityData.reduce(into: 0) { $0 += $1.count }
        return Int(Double(style.count) / Double(total) * 100)
    }
    
    // MARK: - 그래프 클릭시에 선택된 그래프 확인
    func handleSelection() {
        if let selectedData,
           let selectedIndex = cumulativeSalesRanges
            .firstIndex(where: { $0.range.contains(selectedData) }) {
            let version = entityData[selectedIndex].version
            if selectedVersion == version {
                // If tapping the same section, deselect it
                selectedVersion = nil
                isSelected = false
            } else {
                // If tapping a different section, select it
                selectedVersion = version
                isSelected = true
            }
        }
    }
}
