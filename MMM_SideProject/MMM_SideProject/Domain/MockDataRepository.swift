//
//  MockDataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/17/25.
//

import UIKit

class MockDataRepository : DataRepositoryInterface {
    func readTotalData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .income, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .income, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .income, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .income, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .income, amount: "+12,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    func readIncomeData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-24", createType: .income, amount: "+24,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    func readExpendData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-24", createType: .expend, amount: "-24,000원", iconImage: UIImage(named: "DateImage")!)
        ]
    }
}
