//
//  FindRunningApplicationTemporaryFolderTask.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import BoltsSwift

class FindRunningApplicationTemporaryFolderTask {
    fileprivate let fileManager: FileManager
    fileprivate let applicationTemporaryFolderName = "tmp"
    fileprivate let runningFolderEventsListener: FolderEventsListener
    fileprivate let runningTaskCompletionSource = TaskCompletionSource<String>()
    
    init(simulatorApplicationsPath: String, folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory(), fileManager: FileManager = FileManager.default) {
        self.runningFolderEventsListener = folderEventsListenerFactory.iOSSimulatorApplicationsFolderEventsListener(at: simulatorApplicationsPath)
        self.fileManager = fileManager
    }
    
    deinit {
        runningFolderEventsListener.stopListening()
    }
    
    // MARK: - Interface
    
    func run() -> Task<String> {
        runningFolderEventsListener.startListening()
        return runningTaskCompletionSource.task
    }
}

// MARK: - FolderEventsListenerOutput
extension FindRunningApplicationTemporaryFolderTask: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let path = event.path else {
            assertionFailure("FindRunningApplicationTemporaryFolderTask expects to not receive unknown events")
        }
        let possibleApplicationTemporaryFolderPath = path + "/" + applicationTemporaryFolderName
        guard fileManager.fileExists(atPath: possibleApplicationTemporaryFolderPath) else {
            return
        }
        runningTaskCompletionSource.set(result: possibleApplicationTemporaryFolderPath)
    }
}
