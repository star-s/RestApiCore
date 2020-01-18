//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17/01/2020.
//

import Foundation

public struct ApiResponseCodingKey {
    let key: String
    init(_ keyValue: String) { key = keyValue }
}

extension ApiResponseCodingKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { key = value }
}

extension ApiResponseCodingKey: CodingKey {
    public var stringValue: String { key }
    public init?(stringValue: String) { key = stringValue }
    
    public var intValue: Int? { Int(key) }
    public init?(intValue: Int) { key = String(intValue) }
}
