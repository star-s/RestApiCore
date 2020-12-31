//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.12.2020.
//

import Foundation
import RestApiCore

public protocol DataTransport {
    
    func handleResponse<T: Decodable>(_ result: Result<Data, Error>, method: ApiMethod) -> Result<T, Error>

    func performPost<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress
    func performGet<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress
    func performPut<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress
    func performPatch<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress
    func performDelete<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress
}

public extension DataTransport {
    
    func handleResponse<T: Decodable>(_ result: Result<Data, Error>, method: ApiMethod) -> Result<T, Error> {
        result.tryMap { try method.makeJsonDecoder().decode(T.self, from: $0) }
    }
}

extension HttpTransport where Self: DataTransport {
    
    public func POST<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        performPost(method, parameters: parameters) {
            completion(self.handleResponse($0, method: method))
        }
    }
    
    public func GET<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        performGet(method, parameters: parameters) {
            completion(self.handleResponse($0, method: method))
        }
    }
    
    public func PUT<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        performPut(method, parameters: parameters) {
            completion(self.handleResponse($0, method: method))
        }
    }
    
    public func PATCH<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        performPatch(method, parameters: parameters) {
            completion(self.handleResponse($0, method: method))
        }
    }
    
    public func DELETE<R: Encodable, T: Decodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        performDelete(method, parameters: parameters) {
            completion(self.handleResponse($0, method: method))
        }
    }
}
