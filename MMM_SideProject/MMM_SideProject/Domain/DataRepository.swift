//
//  DataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import UIKit
import RealmSwift
import Realm

class DataRepository : DataRepositoryInterface {
    
    private var stateType : ButtonType = .total
    private var dateType : YearMonthDay = .init()
    
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
    
    func readData(typeName: String, color: UIColor) -> [Entity] {
        return []
    }
    
    func readDate() -> String {
        return ""
    }
    
    func readDataOfDay() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readDataOfDay")
            return []
        }
        
        let realmData = realm.objects(UserDB.self)
        
        return realmData.where { $0.dateString == dateType.toStringYearMonthDay() }
            .map { Entity(id: UUID(), dateStr: $0.dateString, createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    func readGraphData() -> [(String, Double)] {
        return []
    }
    
    func readAmountsDict() -> [String : Int] {
        var amountsDict : [String : Int] = .init()
        
        // TODO: - Concurrency 적용 필요
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readAmountsDict")
            return [:]
        }
        
        let realmData = realm.objects(UserDB.self)
        let uniqueDate = Set(realmData.map { $0.dateString })
        
        for dateString in uniqueDate {
            let tempDate = realmData.where {
                $0.dateString == dateString
            }
            
            // MARK: - 해당 Date의 모든 요소 값 계산 후 반환
            let tempAmount = tempDate.reduce(0) { $0 + $1.moneyAmount }
            
            amountsDict[dateString] = tempAmount
        }
        
        return amountsDict
    }
    
    func readDataForCreateCell(of type: CreateType, selectedIndex: Int) -> [CreateCellIcon] {
        return []
    }
    
    func setDate(type: DateButtonType) {
        
    }
    
    func setState(type: ButtonType) {
        
    }
    
    func setDay(of day: Int) {
        
    }
}

private extension DataRepository {
    private func readTotalData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readTotalData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: UUID(), dateStr: $0.dateString, createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage)}
    }
    
    private func readIncomeData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .income }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: UUID(), dateStr: $0.dateString, createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readExpendData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .expend }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: UUID(), dateStr: $0.dateString, createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
}
