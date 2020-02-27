//
//  File.swift
//
//
//  Created by Sergey Starukhin on 29/12/2019.
//

import Foundation

public protocol ApiTransport {
    func perform<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
}

public protocol ApiEndpoint: ApiTransport {
    
    var parent: ApiTransport { get }
    var name: String { get }
}

public extension ApiEndpoint {
    
    func perform<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.perform(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
}
