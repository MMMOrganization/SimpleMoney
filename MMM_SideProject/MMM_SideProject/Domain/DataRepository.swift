//
//  DataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import UIKit
import RealmSwift
import Realm

final class DataRepository : DataRepositoryInterface {
    // MARK: - CalendarVM 에서 사용하는 repository에서는 항상 total 타입
    private var stateType : ButtonType = .total
    
    private var dateType : YearMonthDay = .init()
    
    private var cellIconList : [CreateCellIcon] = .init()
    
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
    
    // MARK: - CalendarVC 에서는 항상 totalData와 하루의 데이터만 사용하기 때문에 이 함수를 사용한다.
    /// For Calendar Function
    /// 하루치에 해당하는 데이터를 가져와야 함.
    func readDataOfDay() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readDataOfDay")
            return []
        }
        
        let realmData = realm.objects(UserDB.self)
        
        return realmData.where { $0.dateString == dateType.toStringYearMonthDay() }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    func readData(typeName : String) -> [Entity] {
        var tempTypeName : String = typeName
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readData(typeName : String)")
            return []
        }
        
        // MARK: - 가장 많은 타입으로 반환.
        /// 아무런 값 (초기값이 들어왔을 때)이 들어오지 않았을 때 가장 많은 타입으로 반환한다.
        if typeName == "" { tempTypeName = readMostTypeName() }
        
        return realm.objects(UserDB.self)
            .filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())' AND createType == 'expend' AND typeString == '\(tempTypeName)'")
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString, createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage)}
            .sorted {
                $0.dateStr > $1.dateStr
            }
    }
    
    func readDate() -> String {
        return dateType.toStringYearMonth()
    }
    
    func readAmountsDict() -> [String : Int] {
        var amountsDict : [String : Int] = .init()

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
    
    func readGraphData() -> [(String, Double)] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readGraphData")
            return []
        }
        
        let userDB = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .expend }
        
        var tempDict : [String : Double] = .init()
        var resultList : [(String, Double)] = []
        
        userDB.forEach {
            if tempDict[$0.typeString] == nil {
                tempDict[$0.typeString] = 1
            }
            else {
                tempDict[$0.typeString]! += 1
            }
        }
        
        for (key, value) in tempDict.sorted(by: { $0.value > $1.value }) {
            resultList.append((key, value))
        }
        
        return resultList
    }
    
    func readInitIconCell() -> [CreateCellIcon] {
        cellIconList = CreateCellIcon.initReadData()
        return cellIconList
    }
    
    func readIconCell() -> [CreateCellIcon] {
        return cellIconList
    }
    
    func setSelectedIconCell(index: Int) {
        for i in 0..<cellIconList.count { cellIconList[i].noneSelected() }
        cellIconList[index].doneSelected()
    }
    
    func readSelectedIconImageType(index: Int) -> IconImageType {
        return cellIconList[index].getImageType()
    }
    
    func readDateList() -> [String] {
        var dateList = Set<String>()
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readDataList")
            return []
        }
        
        let realmData = realm.objects(UserDB.self)
        
        realmData.forEach {
            let tempList = $0.dateString.split(separator: "-")
            dateList.insert("\(tempList[0])년 \(Int(tempList[1]) ?? 0)월")
        }
        
        return dateList.sorted { $0 > $1 }
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
    
    func setDate(dateStr : String) {
        let tempStr = dateStr.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "월", with: "")
            .split(separator: "년")
        
        guard let year = Int(tempStr[0]), let month = Int(tempStr[1]) else {
            print("MockData - setDate year, month 변환 에러")
            return
        }
        
        dateType.setYear(of: year)
        dateType.setMonth(of: month)
    }
    
    func setDay(of day : Int) {
        dateType.setDay(of: day)
    }
    
    func deleteData(id: UUID) {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error deleteData")
            return
        }
        
        try? realm.write {
            let userDB = realm.objects(UserDB.self).where {
                $0.id == id
            }
            
            realm.delete(userDB)
        }
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
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readIncomeData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .income }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readExpendData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .expend }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readMostTypeName() -> String {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readMostTypeName()")
            return ""
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .expend }
            
        var tempDict : [String : Double] = .init()
        
        realmData.forEach {
            if tempDict[$0.typeString] == nil {
                tempDict[$0.typeString] = 1
            }
            else {
                tempDict[$0.typeString]! += 1
            }
        }
        
        guard let mostTypeName = tempDict.sorted(by: { $0.value > $1.value }).first?.key else { return "" }
        
        return mostTypeName
    }
}
