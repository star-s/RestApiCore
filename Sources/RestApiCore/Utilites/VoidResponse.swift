//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01/02/2020.
//

import Foundation

public typealias VoidResponse = Result<VoidValue?, Error>

public struct VoidValue: Decodable {
    public init(from decoder: Decoder) throws {}
}
