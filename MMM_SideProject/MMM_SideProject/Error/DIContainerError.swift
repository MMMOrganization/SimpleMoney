//
//  DIContainerError.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 9/13/25.
//

import Foundation

enum DIContainerError: Error {
    case containerResolveFailure(type: String)
    
    public var description: String {
        switch self {
        case .containerResolveFailure(let typeString):
            return "DIContainer Resolve Failed : \(typeString)"
        }
    }
}
