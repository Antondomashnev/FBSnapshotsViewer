//
//  FolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias FolderEventFilter = (_ isIncluded: FolderEvent) throws -> Bool

protocol FolderEventFilterer {
    static var filter: FolderEventFilter { get }
}

func + (left: @escaping FolderEventFilter, right: @escaping FolderEventFilter) -> FolderEventFilter {
    return { isIncluded in try left(isIncluded) && right(isIncluded) }
}
