//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04/01/2020.
//

import Foundation

extension CodingUserInfoKey: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        guard let infoKey = CodingUserInfoKey(rawValue: value) else {
            preconditionFailure("Invalid string: \(value)")
        }
        self = infoKey
    }
}
