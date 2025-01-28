//
//  GraphView.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/28/25.
//

import SwiftUI
import Charts
import Combine

struct CircleGraphView: View {
    @StateObject private var viewModel: GraphViewModelForSwiftUI
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GraphViewModelForSwiftUI) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        viewModel.$selectedStyle
            .sink { expendCount in
                print(expendCount)
            }.store(in: &cancellables)
    }
    
    var body: some View {
        VStack {
            Chart(viewModel.getEntityData(), id: \.expendType) { element in
                SectorMark(
                    angle: .value("지출 타입", element.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity((element.expendType.rawValue == viewModel.selectedStyle?.expendType.rawValue ?? "") ? 1 : 0.3)
                .foregroundStyle(by: .value("expendType", element.expendType.rawValue))
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
                            Text("지출 타입")
                                .font(.callout)
                            
                            Text("iOS \(selectedStyle.expendType.rawValue)")
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

