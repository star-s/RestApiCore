//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19/02/2020.
//

import Foundation

public protocol HttpTransport {
    
    func GET<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
    func POST<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
    func PUT<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
    func DELETE<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
}

public protocol HttpEndpoint: HttpTransport {
    var parent: HttpTransport { get }
    var name: String { get }
}

public extension HttpEndpoint {
    
    func GET<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.GET(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
    
    func POST<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.POST(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
    
    func PUT<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.PUT(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
    
    func DELETE<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.DELETE(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
}
