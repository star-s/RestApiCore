//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.12.2020.
//

import Foundation
import RestApiCore

public enum PrepareRequestError: Error {
    case cantCreateUrlComponents
    case cantCreateUrl
}

public protocol URLSessionDataTransport: DataTransport {
    
    var baseURL: URL { get }
    
    var session: URLSession { get }

    func httpHeaders(for method: ApiMethod) -> [String : String]?
    
    func preparePostRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest
    func prepareGetRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest
    func preparePutRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest
    func preparePatchRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest
    func prepareDeleteRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest
}

extension URLSessionDataTransport {
    
    public var session: URLSession { .shared }

    public func httpHeaders(for method: ApiMethod) -> [String : String]? { nil }
    
    // MARK: - Prepare request
    
    public func preparePostRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest {
        var request = URLRequest(url: method.url(relativeTo: baseURL))
        request.httpMethod = "POST"
        httpHeaders(for: method)?.forEach({ request.setValue($1, forHTTPHeaderField: $0) })
        request.httpBody = try JSONEncoder().encode(parameters)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func prepareGetRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest {
        guard var components = URLComponents(url: method.url(relativeTo: baseURL), resolvingAgainstBaseURL: true) else {
            throw PrepareRequestError.cantCreateUrlComponents
        }
        components.query = try URLEncodedFormEncoder().encode(parameters)
        guard let url = components.url else {
            throw PrepareRequestError.cantCreateUrl
        }
        var request = URLRequest(url: url)
        httpHeaders(for: method)?.forEach({ request.setValue($1, forHTTPHeaderField: $0) })
        return request
    }
    
    public func preparePutRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest {
        var request = try preparePostRequest(method, parameters: parameters)
        request.httpMethod = "PUT"
        return request
    }
    
    public func preparePatchRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest {
        var request = try preparePostRequest(method, parameters: parameters)
        request.httpMethod = "PATCH"
        return request
    }
    
    public func prepareDeleteRequest<R: Encodable>(_ method: ApiMethod, parameters: R) throws -> URLRequest {
        var request = try prepareGetRequest(method, parameters: parameters)
        request.httpMethod = "DELETE"
        return request
    }
    
    // MARK: - DataTransport
    
    public func performPost<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress {
        do {
            let request = try preparePostRequest(method, parameters: parameters)
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task.progress
        } catch {
            return fakeProgress(method, error: error, completion: completion)
        }
    }
    
    public func performGet<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress {
        do {
            let request = try prepareGetRequest(method, parameters: parameters)
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task.progress
        } catch {
            return fakeProgress(method, error: error, completion: completion)
        }
    }
    
    public func performPut<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress {
        do {
            let request = try preparePutRequest(method, parameters: parameters)
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task.progress
        } catch {
            return fakeProgress(method, error: error, completion: completion)
        }
    }
    
    public func performPatch<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress {
        do {
            let request = try preparePatchRequest(method, parameters: parameters)
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task.progress
        } catch {
            return fakeProgress(method, error: error, completion: completion)
        }
    }
    
    public func performDelete<R: Encodable>(_ method: ApiMethod, parameters: R, completion: @escaping (Result<Data, Error>) -> Void) -> Progress {
        do {
            let request = try prepareDeleteRequest(method, parameters: parameters)
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task.progress
        } catch {
            return fakeProgress(method, error: error, completion: completion)
        }
    }

    // MARK: - Internal stuff
    
    func fakeProgress<T: Decodable>(_ method: ApiMethod, error: Error, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        let progress = Progress.discreteProgress(totalUnitCount: 1)
        session.delegateQueue.addOperation {
            progress.makeFinish()
            completion(self.handleResponse(.failure(error), method: method))
        }
        return progress
    }
}
