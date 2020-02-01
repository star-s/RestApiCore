//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04/01/2020.
//

import Foundation

extension StringProtocol {
    
    public var pathFromCamelCase: String {
        decomposeCamelCase(separator: "/")
    }
    
    public func decomposeCamelCase(separator: String) -> String {
        unicodeScalars.reduce("") { $1.properties.isUppercase ? $0 + separator + String($1).lowercased() : $0 + String($1) }
    }
    
    public func decompose(by length: Int) -> [Self.SubSequence] {
        stride(from: 0, to: count, by: length).map({
            let begin = index(startIndex, offsetBy: $0)
            let end = index(begin, offsetBy: length, limitedBy: endIndex) ?? endIndex
            return self[begin ..< end]
        })
    }
}
