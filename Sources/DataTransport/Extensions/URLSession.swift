//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.12.2020.
//

import Foundation

extension URLSession {

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: request) { (data, response, error) in
            completionHandler(Result {
                switch (data, response, error) {
                case (data, .some(let response as HTTPURLResponse), .none) where response.statusCode == 200:
                    return data ?? Data()
                case (data, .some(let response as HTTPURLResponse), .none):
                    throw HttpError(response: response, data: data)
                case (_, _, .some(let error)):
                    throw error
                default:
                    fatalError("Wrong response") // ???: Maybe throw error is better?
                }
            })
        }
    }
}
