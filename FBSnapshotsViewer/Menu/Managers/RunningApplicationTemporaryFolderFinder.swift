//
//  RunningApplicationTemporaryFolderFinder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class RunningApplicationTemporaryFolderFinder {
    fileprivate let fileManager: FileManager
    fileprivate let applicationTemporaryFolderName = "tmp"
    fileprivate let runningFolderEventsListener: FolderEventsListener?
    
    init(runningFolderEventsListener: FolderEventsListener, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    deinit {
        runningFolderEventsListener.stopListening()
    }
    
    func find() {
        
    }
}

// MARK: - FolderEventsListenerOutput
extension RunningApplicationTemporaryFolderFinder: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let path = event.path else {
            assertionFailure("FindRunningApplicationTemporaryFolderTask expects to not receive unknown events")
            return
        }
        let possibleApplicationTemporaryFolderPath = path + "/" + applicationTemporaryFolderName
        guard fileManager.fileExists(atPath: possibleApplicationTemporaryFolderPath) else {
            return
        }
        runningTaskCompletionSource.set(result: possibleApplicationTemporaryFolderPath)
    }
}
