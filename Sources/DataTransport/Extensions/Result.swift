//
//  Result+Stuff.swift
//  
//
//  Created by Sergey Starukhin on 01/02/2020.
//  Copyright © 2020 Sergey Starukhin. All rights reserved.
//

import Foundation

extension Result {
    
    public func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Failure> where Failure == Error {
        switch self {
        case .success(let value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
