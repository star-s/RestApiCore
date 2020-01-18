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
