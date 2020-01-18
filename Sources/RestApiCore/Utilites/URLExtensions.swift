//
//  URL.swift
//  eReception
//
//  Created by Sergey Starukhin on 18/09/2019.
//  Copyright © 2019 Altarix. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            preconditionFailure("Invalid URL string: \(value)")
        }
        self = url
    }
}
