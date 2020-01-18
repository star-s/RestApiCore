//
//  File.swift
//
//
//  Created by Sergey Starukhin on 29/12/2019.
//

import Foundation

public protocol ApiTransport {
    func perform<R: ApiRequest, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress
    func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress
}

extension ApiTransport {
    
    public func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        fatalError("\(#function) has not been implemented")
    }
}

public protocol ApiEndpoint: ApiTransport {
    
    var parent: ApiTransport { get }
    var name: String { get }
}

public extension ApiEndpoint {
    
    func perform<R: ApiRequest, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.perform(method.appendingPath(prefix: name), parameters: parameters, completion: completion)
    }
    
    func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        parent.upload(attachments, method: method.appendingPath(prefix: name), completion: completion)
    }
}

public extension ApiTransport {
    
    /*
     GET запрос без параметров, чистый сахар
     */
    func perform<T: Decodable>(_ method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        perform(method, parameters: EmptyRequest(), completion: completion)
    }
}

private struct EmptyRequest: GetRequest {}
