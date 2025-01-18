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
    
    // 현재 날짜를 "YYYY년 MM월로 가져오는 로직 필요
    private var dateType : YearMonth = .init()
    
    /// total Read
    /// -> Entity 객체로 이번 달의 전체 엔티티를 리스트로 전달해야 함.
    func readTotalData() -> [Entity] {
        guard let realm = try? Realm() else {
            // 에러 처리 필요 (에러 핸들링은 어떻게 해야할까?)
            return []
        }
        // 지금이 몇 월인지 확인하는 함수를 호출해야 함.
        // 2. Realm 객체의 데이터를 읽어와야 함.
        
        let domainDataResults = realm.objects(UserDB.self)
        
        domainDataResults.map { print($0) }
        
        return []
    }
    
    func readData() -> [Entity] {
        return []
    }
    
    func setState(type: ButtonType) {
        
    }
    
    /// income Read
    /// -> Entity 객체로 이번 달의 수입 엔티티를 리스트로 전달해야 함.
    func readIncomeData() -> [Entity] {
        return []
    }
    
    /// expend Read
    /// -> Entity 객체로 이번 달의 지출 엔티티를 리스트로 전달해야 함.
    func readExpendData() -> [Entity] {
        return []
    }
    
    /// 현재 어떤 버튼이 눌려있는지 상태를 보관해야 함. (Interface 에서는 제공하지 않음.)
    /// -> 현재 상태에 따라서 호출되는 함수는 다름
    func setStateType(_ stateType : ButtonType) {
        // Button 을 누름으로 stateType의 변경.
        self.stateType = stateType
    }
    
    func readDate() -> String {
        return ""
    }
    
    func setDate(type: DateButtonType) {
        
    }
}
