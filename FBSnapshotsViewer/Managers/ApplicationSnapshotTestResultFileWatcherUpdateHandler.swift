//
//  ApplicationSnapshotTestResultFileWatcherUpdateHandler.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import KZFileWatchers

class ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder {
    var applicationLogReader: ApplicationLogReader = ApplicationLogReader()
    var snapshotTestResultFactory: SnapshotTestResultFactory = SnapshotTestResultFactory()
    var applicationNameExtractor: ApplicationNameExtractor = XcodeApplicationNameExtractor()
    var fbImageReferenceDirExtractor: FBReferenceImageDirectoryURLExtractor = XcodeFBReferenceImageDirectoryURLExtractor()
    var buildCreator: BuildCreator = BuildCreator()
    
    typealias BuilderClojure = (ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder) -> Void
    
    init(clojure: BuilderClojure) {
        clojure(self)
    }
}

struct ApplicationSnapshotTestResultFileWatcherUpdateHandlerReadInfo {
    /// Number of lines already read
    var readLinesNumber: Int = 0
    
    /// By 'result' application log line meant either:
    /// .kaleidoscopeCommandMessage or .referenceImageSavedMessage
    var lastReadResultApplicationLogLine: ApplicationLogLine? {
        didSet {
            guard let newValue = lastReadResultApplicationLogLine else {
                return
            }
            switch newValue {
            case .applicationNameMessage, .fbReferenceImageDirMessage, .snapshotTestErrorMessage, .unknown:
                assertionFailure("Invalid value \(newValue) for `lastReadResultApplicationLogLine`. Expected either kaleidoscopeCommandMessage or referenceImageSavedMessage")
            default:
                return
            }
        }
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandler {
    private let applicationLogReader: ApplicationLogReader
    private let snapshotTestResultFactory: SnapshotTestResultFactory
    private let applicationNameExtractor: ApplicationNameExtractor
    private let fbImageReferenceDirExtractor: FBReferenceImageDirectoryURLExtractor
    private let buildCreator: BuildCreator
    private var readInfo: ApplicationSnapshotTestResultFileWatcherUpdateHandlerReadInfo
    
    init(builder: ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder = ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder(clojure: { _ in })) {
        self.applicationLogReader = builder.applicationLogReader
        self.snapshotTestResultFactory = builder.snapshotTestResultFactory
        self.applicationNameExtractor = builder.applicationNameExtractor
        self.buildCreator = builder.buildCreator
        self.fbImageReferenceDirExtractor = builder.fbImageReferenceDirExtractor
        self.readInfo = ApplicationSnapshotTestResultFileWatcherUpdateHandlerReadInfo()
    }
    
    // MARK: - Interface
    
    @discardableResult func handleFileWatcherUpdate(result: KZFileWatchers.FileWatcher.RefreshResult) -> [SnapshotTestResult] {
        switch result {
        case .noChanges:
            return []
        case let .updated(data):
            guard let text = String(data: data, encoding: .utf8), !text.isEmpty else {
                assertionFailure("Invalid data reported by KZFileWatchers.FileWatcher.Local")
                return []
            }
            do {
                return try handleFileWatcherUpdate(text: text) ?? []
            }
            catch let error {
                assertionFailure("\(error)")
                return []
            }
        }
    }
    
    // MARK: - Helpers
    
    private func collectSnapshotTestResults(result: [SnapshotTestResult], logLine: ApplicationLogLine) throws -> [SnapshotTestResult] {
        var nextResult = result
        switch logLine {
        case .fbReferenceImageDirMessage:
            buildCreator.fbReferenceImageDirectoryURLs = try fbImageReferenceDirExtractor.extractImageDirectoryURLs(from: logLine)
        case .applicationNameMessage:
            buildCreator.applicationName = try applicationNameExtractor.extractApplicationName(from: logLine)
            buildCreator.date = Date()
        case .kaleidoscopeCommandMessage:
            readInfo.lastReadResultApplicationLogLine = logLine
        case .referenceImageSavedMessage:
            readInfo.lastReadResultApplicationLogLine = logLine
        case .snapshotTestErrorMessage:
            guard let build = buildCreator.createBuild(),
                  let resultLogLine = readInfo.lastReadResultApplicationLogLine else {
                assertionFailure("Unexpected snapshot test result line \(logLine) before build information line or without referenceImageSavedMessage or kaleidoscopeCommandMessage line")
                return nextResult
            }
            guard let snapshotTestResult = snapshotTestResultFactory.createSnapshotTestResult(from: resultLogLine, errorLine: logLine, build: build) else {
                assertionFailure("Internal conditions are not valid to create snapshot test result")
                return nextResult
            }
            nextResult.append(snapshotTestResult)
        default: break
        }
        return nextResult
    }
    
    private func handleFileWatcherUpdate(text: String) throws -> [SnapshotTestResult]? {
        let logLines = applicationLogReader.readline(of: text, startingFrom: readInfo.readLinesNumber)
        let snapshotTestResults = try logLines.reduce([], collectSnapshotTestResults)
        readInfo.readLinesNumber += logLines.count
        return snapshotTestResults
    }
}
