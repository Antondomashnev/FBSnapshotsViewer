//
//  ApplicationTemporaryFolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class ApplicationTemporaryFolderEventFilter: FolderEventFilterer {
    static let applicationTemporaryFolderRegex = "\\/data\\/Containers\\/Data\\/Application\\/.{8}-.{4}-.{4}-.{4}-.{12}\\/tmp"
    
    static var filter: FolderEventFilter = { isIncluded in
        switch isIncluded {
        case let .created(path, type) where type == .folder && path.range(of: applicationTemporaryFolderRegex, options: NSString.CompareOptions.regularExpression) != nil:
            return true
        default: return false
        }
    }
}
