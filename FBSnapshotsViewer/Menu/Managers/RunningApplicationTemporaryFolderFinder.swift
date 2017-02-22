//
//  RunningApplicationTemporaryFolderFinder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias RunningApplicationTemporaryFolderFinderCompletion = (String) -> Void

struct RunningApplicationTemporaryFolderFinderAction {
    let completionHandler: RunningApplicationTemporaryFolderFinderCompletion
    let folderEventsListener: FolderEventsListener
    let simulatorPath: String
    
    func run() {
        folderEventsListener.startListening()
    }
    
    func stop() {
        folderEventsListener.stopListening()
    }
}

class RunningApplicationTemporaryFolderFinder {
    fileprivate let fileManager: FileManager
    fileprivate let applicationTemporaryFolderName = "tmp"
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    fileprivate var runningAction: RunningApplicationTemporaryFolderFinderAction?
    
    init(folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory(), fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.folderEventsListenerFactory = folderEventsListenerFactory
    }
    
    deinit {
        resetRunningAction()
    }
    
    func find(in simulatorPath: String, with completion: @escaping RunningApplicationTemporaryFolderFinderCompletion) {
        resetRunningAction()
        var folderEventsListener = folderEventsListenerFactory.iOSSimulatorApplicationsFolderEventsListener(at: simulatorPath)
        folderEventsListener.output = self
        runningAction = RunningApplicationTemporaryFolderFinderAction(completionHandler: completion, folderEventsListener: folderEventsListener, simulatorPath: simulatorPath)
        runningAction?.run()
    }
    
    // MARK: - Helpers
    
    func resetRunningAction() {
        runningAction?.stop()
        runningAction = nil
    }
    
}

// MARK: - FolderEventsListenerOutput
extension RunningApplicationTemporaryFolderFinder: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let path = event.path else {
            assertionFailure("RunningApplicationTemporaryFolderFinder expects to not receive unknown events")
            return
        }
        guard let runningAction = runningAction else {
            assertionFailure("RunningApplicationTemporaryFolderFinder expects to have a running action")
            return
        }
        let possibleApplicationTemporaryFolderPath = path + "/" + applicationTemporaryFolderName
        guard fileManager.fileExists(atPath: possibleApplicationTemporaryFolderPath) else {
            return
        }
        runningAction.completionHandler(possibleApplicationTemporaryFolderPath)
    }
}
