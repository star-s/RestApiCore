//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01/02/2020.
//

import Foundation

public struct VoidResponse: Decodable {
}

public struct VoidRequest: Encodable {
    public init() {}
}
