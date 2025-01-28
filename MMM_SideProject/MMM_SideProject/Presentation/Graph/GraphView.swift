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

struct CircleGraphView: View {
    @StateObject private var viewModel: GraphViewModelForSwiftUI
    
    init(viewModel: GraphViewModelForSwiftUI = GraphViewModelForSwiftUI()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Chart(viewModel.entityData, id: \.version) { element in
                SectorMark(
                    angle: .value("Usage", element.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity((element.version == viewModel.selectedStyle?.version ?? "") ? 1 : 0.3)
                .foregroundStyle(by: .value("Version", element.version))
            }
            .chartLegend(.hidden)
            .chartAngleSelection(value: $viewModel.selectedData)
            .padding()
            .scaledToFit()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    
                    VStack {
                        if let selectedStyle = viewModel.selectedStyle {
                            Text("Usage")
                                .font(.callout)
                            
                            Text("iOS \(selectedStyle.version)")
                                .font(.title.bold())
                            
                            Text("\(viewModel.calculatePercentage(for: selectedStyle)) %")
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            .onTapGesture {
                viewModel.handleSelection()
            }
        }
    }
}

#Preview {
    CircleGraphView()
}

