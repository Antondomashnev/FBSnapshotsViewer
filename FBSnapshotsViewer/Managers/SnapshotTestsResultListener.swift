//
//  SnapshotTestsResultListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa
import SwiftFSWatcher

final class SnapshotTestsResultListener {
    private let folderWatcher: SwiftFSWatcher
    
    init(testResultsFolderPath: String) {
        self.folderWatcher = SwiftFSWatcher([testResultsFolderPath])
    }
}
