//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02/01/2020.
//

import Foundation

public struct ApiMethod {
    
    public let path: String
    public let resultKeyPath: [ApiResponseKey]?
    
    public init(_ path: String, resultKeyPath: [ApiResponseKey]? = nil) {
        self.path = path
        self.resultKeyPath = resultKeyPath
    }
    
    public func appendingPath(suffix aPath: String) -> Self {
        ApiMethod((path as NSString).appendingPathComponent(aPath), resultKeyPath: resultKeyPath)
    }
    
    public func appendingPath(prefix aPath: String) -> Self {
        ApiMethod((aPath as NSString).appendingPathComponent(path), resultKeyPath: resultKeyPath)
    }
    
    public func url(relativeTo baseURL: URL? = nil) -> URL {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            fatalError("Can't create url from \(String(describing: baseURL)) & \(path)")
        }
        return url
    }
}

extension ApiMethod: CustomStringConvertible {
    public var description: String { path }
}

extension ApiMethod: ExpressibleByStringLiteral {
    
    /*
     method                                                     - path: method, resultKeyPath: nil
     method()                                                   - path: method, resultKeyPath: nil
     method(keyPathInCamelCase)                                 - path: method, resultKeyPath: [key,path,in,camel,case]
     method(keyPathInCamelCase:)                                - path: method, resultKeyPath: [key,path,in,camel,case]
     method(param1:param2:keyPathInCamelCase:)                  - path: method, resultKeyPath: [key,path,in,camel,case]
     methodNameInCamelCase(param1:param2:keyPathInCamelCase:)   - path: methodNameInCamelCase, resultKeyPath: [key,path,in,camel,case]
     */
    public init(stringLiteral value: String) {
        
        if value.isEmpty {
            self = ApiMethod(value)
            return
        }
        var components = value.split(separator: "(")
        
        let path = String(components.removeFirst())
        
        if components.isEmpty {
            self = ApiMethod(path)
            return
        }
        guard let keyPathSubstring = components.removeFirst().split(separator: ")").first?.split(separator: ":").last else {
            self = ApiMethod(path)
            return
        }
        let keys = keyPathSubstring.pathFromCamelCase.split(separator: "/").map({ ApiResponseKey(rawValue: String($0)) })
        if keys.isEmpty {
            self = ApiMethod(path)
        } else {
            self = ApiMethod(path, resultKeyPath: keys)
        }
    }
}

extension ApiMethod {
    
    func makeJsonDecoder(_ constructor: @autoclosure () -> JSONDecoder = JSONDecoder()) -> JSONDecoder {
        let decoder = constructor()
        if let keyPath = resultKeyPath {
            decoder.userInfo[.resultDecodeKeyPath] = keyPath
        }
        return decoder
    }
}

extension CodingUserInfoKey {
    public static let resultDecodeKeyPath: CodingUserInfoKey = "resultDecodeKeyPath" // Array<ApiResponseKey>
}
