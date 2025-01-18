//
//  MockDataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/17/25.
//

import UIKit

class MockDataRepository : DataRepositoryInterface {
    
    private var stateType : ButtonType = .total
    
    // 현재 날짜를 "YYYY년 MM월로 가져오는 로직 필요
    private var dateType : YearMonth = .init()
    
    func readData() -> [Entity] {
        switch stateType {
        case .total:
            return readTotalData()
        case .income:
            return readIncomeData()
        case .expend:
            return readExpendData()
        }
    }
    
    func readDate() -> String {
        return dateType.toString()
    }
    
    func setState(type : ButtonType) {
        switch type {
        case .total:
            stateType = .total
        case .income:
            stateType = .income
        case .expend:
            stateType = .expend
        }
    }
    
    func setDate(type : DateButtonType) {
        switch type {
        case .increase:
            dateType.increase()
            return
        case .decrease:
            dateType.decrease()
            return
        }
    }
}

private extension MockDataRepository {
    private func readTotalData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    private func readIncomeData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    private func readExpendData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
}
