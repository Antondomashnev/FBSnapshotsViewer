//
//  KnownFolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class KnownFolderEventFilter: FolderEventFilterer {
    static var filter: FolderEventFilter = { isIncluded in
        switch isIncluded {
        case .unknown:
            return false
        default: return true
        }
    }
}
