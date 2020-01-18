//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 29/12/2019.
//

import Foundation

public enum HttpMethod: String {
    case get
    case post
    case delete
    case put
}

public protocol ApiRequest: Encodable {
    var httpMethod: HttpMethod { get }
}

// MARK: - Запросы по методу отправки

public protocol GetRequest: ApiRequest {}

extension GetRequest {
    public var httpMethod: HttpMethod { .get }
}

public protocol PostRequest: ApiRequest {}

extension PostRequest {
    public var httpMethod: HttpMethod { .post }
}

public protocol DeleteRequest: ApiRequest {}

extension DeleteRequest {
    public var httpMethod: HttpMethod { .delete }
}

public protocol PutRequest: ApiRequest {}

extension PutRequest {
    public var httpMethod: HttpMethod { .put }
}
