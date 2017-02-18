//
//  FolderEventFilter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol FolderEventFilter {
    static func filter(_ isIncluded: FolderEvent) throws -> Bool
}
