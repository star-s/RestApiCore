//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17/01/2020.
//

import Foundation

extension HTTPURLResponse {
    
    public var textEncoding: String.Encoding {
        guard let encodingName = textEncodingName else {
            return .ascii
        }
        let encoding = CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)
        if encoding == kCFStringEncodingInvalidId {
            return .ascii
        }
        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(encoding))
    }
}
