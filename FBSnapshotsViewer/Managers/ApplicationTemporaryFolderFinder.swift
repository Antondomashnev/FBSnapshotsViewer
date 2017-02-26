//
//  ApplicationTemporaryFolderFinder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias ApplicationTemporaryFolderFinderOutput = (String) -> Void

struct ApplicationTemporaryFolderFinderAction {
    let output: ApplicationTemporaryFolderFinderOutput
    let folderEventsListener: FolderEventsListener
    let simulatorPath: String
    
    func run() {
        folderEventsListener.startListening()
    }
    
    func stop() {
        folderEventsListener.stopListening()
    }
}

class ApplicationTemporaryFolderFinder {
    fileprivate let fileManager: FileManager
    fileprivate let applicationTemporaryFolderName = "tmp"
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    fileprivate var runningAction: ApplicationTemporaryFolderFinderAction?
    
    init(folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory(), fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.folderEventsListenerFactory = folderEventsListenerFactory
    }
    
    deinit {
        resetRunningAction()
    }
    
    func find(in simulatorPath: String, outputTo completion: @escaping ApplicationTemporaryFolderFinderOutput) {
        resetRunningAction()
        var folderEventsListener = folderEventsListenerFactory.iOSSimulatorApplicationsFolderEventsListener(at: simulatorPath)
        folderEventsListener.output = self
        runningAction = ApplicationTemporaryFolderFinderAction(output: completion, folderEventsListener: folderEventsListener, simulatorPath: simulatorPath)
        runningAction?.run()
    }
    
    // MARK: - Helpers
    
    func resetRunningAction() {
        runningAction?.stop()
        runningAction = nil
    }
    
}

// MARK: - FolderEventsListenerOutput
extension ApplicationTemporaryFolderFinder: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let path = event.path else {
            assertionFailure("ApplicationTemporaryFolderFinder expects to not receive unknown events")
            return
        }
        guard let runningAction = runningAction else {
            assertionFailure("ApplicationTemporaryFolderFinder expects to have a running action")
            return
        }
        let possibleApplicationTemporaryFolderPath = path + "/" + applicationTemporaryFolderName
        guard fileManager.fileExists(atPath: possibleApplicationTemporaryFolderPath) else {
            return
        }
        runningAction.output(possibleApplicationTemporaryFolderPath)
    }
}
