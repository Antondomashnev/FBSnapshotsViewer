//
//  ApplicationSnapshotTestResultListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import KZFileWatchers

typealias ApplicationSnapshotTestResultListenerOutput = (SnapshotTestResult) -> Void

class ApplicationSnapshotTestResultListener {
    private var listeningOutput: ApplicationSnapshotTestResultListenerOutput?
    private let fileWatcher: KZFileWatchers.FileWatcher.Local
    private let applicationLogReader: ApplicationLogReader

    init(fileWatcher: KZFileWatchers.FileWatcher.Local, applicationLogReader: ApplicationLogReader) {
        self.fileWatcher = fileWatcher
        self.applicationLogReader = applicationLogReader
    }

    deinit {
        resetRunningAction()
    }

    func startListening(outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        resetRunningAction()
        listeningOutput = completion
        do {
            try fileWatcher.start { [weak self] result in
                self?.handleFileWatcherUpdate(result: result)
            }
        }
        catch KZFileWatchers.FileWatcher.Error.alreadyStarted {
            resetRunningAction()
            startListening(outputTo: completion)
        }
        catch let error {
            switch error {
            case let KZFileWatchers.FileWatcher.Error.failedToStart(reason):
                print("Failed to start listening: \(reason)")
            default:
                print("Failed to start listening: Unknown reason")
            }
        }
    }

    func stopListening() {
        resetRunningAction()
    }

    // MARK: - Helpers

    private func handleFileWatcherUpdate(result: KZFileWatchers.FileWatcher.RefreshResult) {

    }

    private func resetRunningAction() {
        listeningOutput = nil
        try? fileWatcher.stop()
    }
}
