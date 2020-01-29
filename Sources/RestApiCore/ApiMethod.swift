//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02/01/2020.
//

import Foundation

public struct ApiMethod {
    
    public let path: String
    public let resultKeyPath: String?
    
    public init(_ path: String, resultKeyPath: String? = nil) {
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
     method(keyPathInCamelCase)                                 - path: method, resultKeyPath: key/path/in/camel/case
     method(keyPathInCamelCase:)                                - path: method, resultKeyPath: key/path/in/camel/case
     method(param1:param2:keyPathInCamelCase:)                  - path: method, resultKeyPath: key/path/in/camel/case
     methodNameInCamelCase(param1:param2:keyPathInCamelCase:)   - path: method/name/in/camel/case, resultKeyPath: key/path/in/camel/case
     */
    public init(stringLiteral value: String) {
        
        var components = value.split(separator: "(")
        
        let path = components.removeFirst().pathFromCamelCase
        
        if components.isEmpty {
            self = ApiMethod(path)
            return
        }
        guard let keyPathSubstring = components.removeFirst().split(separator: ")").first?.split(separator: ":").last else {
            self = ApiMethod(path)
            return
        }
        self = ApiMethod(path, resultKeyPath: keyPathSubstring.pathFromCamelCase)
    }
}

extension CodingUserInfoKey {
    public static let resultDecodeKeyPath: CodingUserInfoKey = "resultDecodeKeyPath" // Array<ApiResponseKey>
}

extension ApiMethod {
    
    public var resultDecodeKeyPath: [ApiResponseKey]? {
        resultKeyPath?.split(separator: "/").map({ ApiResponseKey(rawValue: String($0)) })
    }
}
