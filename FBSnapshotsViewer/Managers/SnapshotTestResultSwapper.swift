//
//  SnapshotTestResultSwapper.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class SnapshotTestResultSwapper {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
}
