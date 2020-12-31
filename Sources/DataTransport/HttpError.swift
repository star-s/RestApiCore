//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.12.2020.
//

import Foundation

public struct HttpError {
    public let response: HTTPURLResponse
    public let data: Data?
}

extension HttpError: LocalizedError {
    
    public var errorDescription: String? {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }
}
