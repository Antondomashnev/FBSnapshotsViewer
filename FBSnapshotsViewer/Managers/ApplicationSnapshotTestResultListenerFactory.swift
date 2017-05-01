//
//  ApplicationSnapshotTestResultListenerFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import KZFileWatchers

class ApplicationSnapshotTestResultListenerFactory {
    // MARK: - Interface

    func applicationSnapshotTestResultListener(forLogFileAt path: String) -> ApplicationSnapshotTestResultListener {
        let fileWatcher = KZFileWatchers.FileWatcher.Local(path: path)
        let reader = ApplicationLogReader()
        return ApplicationSnapshotTestResultListener(fileWatcher: fileWatcher, applicationLogReader: reader)
    }
}
