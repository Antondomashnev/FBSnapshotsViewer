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
    private var readLinesNumber: Int = 0
    private var listeningOutput: ApplicationSnapshotTestResultListenerOutput?
    private let fileWatcher: KZFileWatchers.FileWatcherProtocol
    private let applicationLogReader: ApplicationLogReader
    private let snapshotTestResultFactory: SnapshotTestResultFactory

    init(fileWatcher: KZFileWatchers.FileWatcherProtocol, applicationLogReader: ApplicationLogReader = ApplicationLogReader(), snapshotTestResultFactory: SnapshotTestResultFactory = SnapshotTestResultFactory()) {
        self.fileWatcher = fileWatcher
        self.applicationLogReader = applicationLogReader
        self.snapshotTestResultFactory = snapshotTestResultFactory
    }

    deinit {
        reset()
    }

    func startListening(outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        reset()
        listeningOutput = completion
        do {
            try fileWatcher.start { [weak self] result in
                self?.handleFileWatcherUpdate(result: result)
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

    // MARK: - Helpers

    private func handleFileWatcherUpdate(result: KZFileWatchers.FileWatcher.RefreshResult) {
        guard let listeningOutput = listeningOutput else {
            return
        }
        switch result {
        case .noChanges:
            return
        case let .updated(data):
            guard let text = String(data: data, encoding: .utf8), !text.isEmpty else {
                assertionFailure("Invalid data reported by KZFileWatchers.FileWatcher.Local")
                return
            }
            let logLines = applicationLogReader.readline(of: text, startingFrom: readLinesNumber)
            let snapshotTestResults = logLines.flatMap { logLine -> SnapshotTestResult? in
                switch logLine {
                case .unknown:
                    return nil
                default:
                    return snapshotTestResultFactory.createSnapshotTestResult(from: logLine)
                }
            }
            snapshotTestResults.forEach { listeningOutput($0) }
            readLinesNumber += logLines.count
        }
    }

    private func reset() {
        readLinesNumber = 0
        listeningOutput = nil
        try? fileWatcher.stop()
    }
}
