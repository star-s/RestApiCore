//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17/01/2020.
//

import Foundation

public struct ApiResponseKey: RawRepresentable, CodingKey {
    public let rawValue: String
    public init?(rawValue: String) { self.rawValue = rawValue }

    public init(_ key: String) { rawValue = key }
}

extension ApiResponseKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { rawValue = value }
}
