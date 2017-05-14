//
//  ApplicationTestLogFilesListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 23.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias ApplicationTestLogFilesListenerOutput = (String) -> Void

struct ApplicationTestLogFilesListenerAction {
    let output: ApplicationTestLogFilesListenerOutput
    let folderEventsListener: FolderEventsListener

    func run() {
        folderEventsListener.startListening()
    }

    func stop() {
        folderEventsListener.stopListening()
    }
}

class ApplicationTestLogFilesListener {
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    fileprivate var runningAction: ApplicationTestLogFilesListenerAction?

    init(folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory()) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
    }

    deinit {
        resetRunningAction()
    }

    func listen(derivedDataFolder: String, outputTo completion: @escaping ApplicationTestLogFilesListenerOutput) {
        resetRunningAction()
        var folderEventsListener = folderEventsListenerFactory.applicationTestLogsEventsListener(at: derivedDataFolder)
        folderEventsListener.output = self
        runningAction = ApplicationTestLogFilesListenerAction(output: completion, folderEventsListener: folderEventsListener)
        runningAction?.run()
    }

    func stopListening() {
        resetRunningAction()
    }

    // MARK: - Helpers

    private func resetRunningAction() {
        runningAction?.stop()
        runningAction = nil
    }
}

// MARK: - FolderEventsListenerOutput
extension ApplicationTestLogFilesListener: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let eventPath = event.path else {
            print("Unexpected event in ApplicationSnapshotTestResultListener: \(event)")
            return
        }
        runningAction?.output(eventPath)
    }
}
