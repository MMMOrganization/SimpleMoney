//
//  GraphView.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/28/25.
//

import SwiftUI
import Charts

struct iPhoneOperationSystem {
    let version: String
    let count: Int
    
    static func dummyData() -> [iPhoneOperationSystem] {
        return [
            iPhoneOperationSystem(version: "16.0", count: 81),
            iPhoneOperationSystem(version: "15.0", count: 13),
            iPhoneOperationSystem(version: "14.0", count: 6)
        ]
    }
}

struct CircleGraphView : View {
    
    var entityData: [iPhoneOperationSystem]
    
    @State var selectedData: Double?
    
    let cumulativeSalesRangesForStyle: [(version: String, range: Range<Double>)]
    
    init(entityData: [iPhoneOperationSystem]) {
        self.entityData = entityData
        
        var cumulative = 0.0
        
        self.cumulativeSalesRangesForStyle = entityData.map {
            let newCumulative = cumulative + Double($0.count)
            let result = (version: $0.version, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
            
        }
    }
    
    var selectedStyle: iPhoneOperationSystem? {
        if let selectedData,
           let selectedIndex = cumulativeSalesRangesForStyle
            .firstIndex(where: { $0.range.contains(selectedData)}) {
            return entityData[selectedIndex]
        }
        
        return nil
    }
    
    var body: some View {
        VStack {
            
            Chart(entityData, id: \.version) { element in
                SectorMark(
                    angle: .value("Usage", element.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity((element.version == selectedStyle?.version ?? "") ? 1 : 0.3)
                .foregroundStyle(by: .value("Version", element.version))
            }
            .chartLegend(.hidden)
            .chartAngleSelection(value: $selectedData)
            .padding()
            .scaledToFit()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    
                    VStack {
                        if let selectedStyle {
                            Text("Usage")
                                .font(.callout)
                            
                            Text("iOS \(selectedStyle.version)")
                                .font(.title.bold())
                            
                            let percentage = Int(Double(selectedStyle.count) / Double(entityData.reduce(into: 0) { $0 += $1.count}) * 100)
                            
                            Text("\(percentage) %")

                        }
                        
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
                
            }
        }
    }
}

#Preview {
    CircleGraphView(entityData: iPhoneOperationSystem.dummyData())
}

