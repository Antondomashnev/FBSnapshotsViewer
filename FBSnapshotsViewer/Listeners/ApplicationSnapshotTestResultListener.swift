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
    private let fileWatcher: KZFileWatchers.FileWatcherProtocol
    private let fileWatcherUpdateHandler: ApplicationSnapshotTestResultFileWatcherUpdateHandler
    
    init(fileWatcher: KZFileWatchers.FileWatcherProtocol,
         fileWatcherUpdateHandler: ApplicationSnapshotTestResultFileWatcherUpdateHandler) {
        self.fileWatcher = fileWatcher
        self.fileWatcherUpdateHandler = fileWatcherUpdateHandler
    }

    deinit {
        reset()
    }

    func startListening(outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        reset()
        listeningOutput = completion
        do {
            try fileWatcher.start { [weak self] result in
                guard let listeningOutput = self?.listeningOutput,
                      let testResults = self?.fileWatcherUpdateHandler.handleFileWatcherUpdate(result: result),
                      !testResults.isEmpty else {
                    return
                }
                testResults.forEach { listeningOutput($0) }
            }
        }
        catch let error {
            switch error {
            case KZFileWatchers.FileWatcher.Error.alreadyStarted:
                assertionFailure("Failed to start listening: Already started")
            case let KZFileWatchers.FileWatcher.Error.failedToStart(reason):
                print("Failed to start listening: \(reason)")
            default:
                print("Failed to start listening: Unknown reason")
            }
        }
    }

    func stopListening() {
        reset()
    }

    private func reset() {
        listeningOutput = nil
        try? fileWatcher.stop()
    }
}
