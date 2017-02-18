//
//  ApplicationTemporaryFolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class ApplicationTemporaryFolderEventFilter: FolderEventFilter {
    static let applicationTemporaryFolderRegex = "\\/data\\/Containers\\/Data\\/Application\\/.{8}-.{4}-.{4}-.{4}-.{12}\\/tmp"
    
    static func filter(_ isIncluded: FolderEvent) throws -> Bool {
        switch isIncluded {
        case let .created(path, type) where path.range(of: applicationTemporaryFolderRegex, options: NSString.CompareOptions.regularExpression) != nil:
            return true
        default: return false
        }
    }
}
