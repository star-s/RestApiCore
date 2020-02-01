//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01/02/2020.
//

import Foundation

public struct DeviceToken: RawRepresentable {
    
    public let rawValue: Data
    
    public init(rawValue: Data) {
        self.rawValue = rawValue
    }
}

extension DeviceToken: LosslessStringConvertible {
    
    public init(_ description: String) {
        rawValue = Data(description.decompose(by: 2).compactMap({ UInt8($0, radix: 16) }))
    }
    
    public var description: String {
        rawValue.map({ String(format: "%02hhx", $0) }).joined()
    }
}

extension DeviceToken: Codable {
    
    public init(from decoder: Decoder) throws {
        self.init(try decoder.singleValueContainer().decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
