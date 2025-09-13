//
//  DIContainer.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

enum DIContainerError {
    
}

public class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private var dictionaries: [String : Any] = [:]
    
    public func register<T>(key: T.Type, value: T) {
        dictionaries[String(describing: key)] = value
    }
    
    public func resolve<T>(key: T.Type) throws -> T {
        guard let value = dictionaries[String(describing: key)] as? T else {
            throw DIContainerError.containerResolveFailure
        }
        return value
    }
}
