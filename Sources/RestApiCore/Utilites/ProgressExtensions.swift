//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17/01/2020.
//

import Foundation

extension Progress {
    
    public func makeFinish() {
        if isFinished || isCancelled {
            return
        }
        if totalUnitCount > 0 {
            completedUnitCount = totalUnitCount
        } else if completedUnitCount > 0 {
            totalUnitCount = completedUnitCount
        } else {
            totalUnitCount = 1
            completedUnitCount = 1
        }
    }
}
