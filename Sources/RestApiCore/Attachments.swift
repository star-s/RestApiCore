//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 31/12/2019.
//

import Foundation

public protocol Attachment {
    var name: String { get }
}

public protocol MediaAttachment: Attachment {
    var fileName: String { get }
    var mimeType: String { get }
}

public protocol DataAttachment: Attachment {
    var data: Data { get }
}

public protocol FileUrlAttachment: Attachment {
    var fileURL: URL { get }
}

public protocol StreamAttachment: MediaAttachment {
    var stream: InputStream { get }
    var length: UInt64 { get }
}

public protocol AttachmentUploader {
    func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress
}

extension ApiEndpoint where Self: AttachmentUploader {
    
    public func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        guard let parentUploader = parent as? AttachmentUploader else {
            fatalError("\(parent) must support AttachmentUploader protocol")
        }
        return parentUploader.upload(attachments, method: method.appendingPath(prefix: name), completion: completion)
    }
}

extension HttpEndpoint where Self: AttachmentUploader {
    
    public func upload<T: Decodable>(_ attachments: [Attachment], method: ApiMethod, completion: @escaping (Result<T, Error>) -> Void) -> Progress {
        guard let parentUploader = parent as? AttachmentUploader else {
            fatalError("\(parent) must support AttachmentUploader protocol")
        }
        return parentUploader.upload(attachments, method: method.appendingPath(prefix: name), completion: completion)
    }
}
