//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17/01/2020.
//

import Foundation

public struct ApiResponseKey: RawRepresentable, CodingKey, Equatable, Hashable {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
}

extension ApiResponseKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { rawValue = value }
}
