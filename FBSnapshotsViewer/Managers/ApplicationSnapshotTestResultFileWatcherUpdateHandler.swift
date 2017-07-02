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

class ApplicationSnapshotTestResultFileWatcherUpdateHandler {
    private let applicationLogReader: ApplicationLogReader
    private let snapshotTestResultFactory: SnapshotTestResultFactory
    private let applicationNameExtractor: ApplicationNameExtractor
    private let fbImageReferenceDirExtractor: FBReferenceImageDirectoryURLExtractor
    private let buildCreator: BuildCreator
    private var readLinesNumber: Int = 0
    
    init(builder: ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder = ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder(clojure: { _ in })) {
        self.applicationLogReader = builder.applicationLogReader
        self.snapshotTestResultFactory = builder.snapshotTestResultFactory
        self.applicationNameExtractor = builder.applicationNameExtractor
        self.buildCreator = builder.buildCreator
        self.fbImageReferenceDirExtractor = builder.fbImageReferenceDirExtractor
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
    
    private func handleFileWatcherUpdate(text: String) throws -> [SnapshotTestResult]? {
        let logLines = applicationLogReader.readline(of: text, startingFrom: readLinesNumber)
        let snapshotTestResults = try logLines.flatMap { logLine -> SnapshotTestResult? in
            switch logLine {
            case .unknown:
                return nil
            case .fbReferenceImageDirMessage:
                buildCreator.fbReferenceImageDirectoryURL = try fbImageReferenceDirExtractor.extractImageDirectoryURL(from: logLine)
                return nil
            case .applicationNameMessage:
                buildCreator.applicationName = try applicationNameExtractor.extractApplicationName(from: logLine)
                buildCreator.date = Date()
                return nil
            default:
                guard let build = buildCreator.createBuild() else {
                    assertionFailure("Unexpected snapshot test result line \(logLine) before build information line")
                    return nil
                }
                return snapshotTestResultFactory.createSnapshotTestResult(from: logLine, build: build)
            }
        }
        readLinesNumber += logLines.count
        return snapshotTestResults
    }
}
