//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 29/12/2019.
//

import Foundation

public protocol ApiRequest: Encodable {
}

public struct VoidRequest: ApiRequest {
    public init() {}
}
