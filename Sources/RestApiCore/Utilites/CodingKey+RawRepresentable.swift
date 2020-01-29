//
//  CodingKey+RawRepresentable.swift
//  OurCIty2
//
//  Created by Sergey Starukhin on 26/01/2020.
//  Copyright © 2020 Sergey Starukhin. All rights reserved.
//

import Foundation

extension CodingKey where Self : RawRepresentable, Self.RawValue == String {
    
    public var stringValue: String { rawValue }
    public init?(stringValue: String) { self.init(rawValue: stringValue) }
    
    public var intValue: Int? { Int(rawValue) }
    public init?(intValue: Int) { self.init(rawValue: String(intValue)) }
}
