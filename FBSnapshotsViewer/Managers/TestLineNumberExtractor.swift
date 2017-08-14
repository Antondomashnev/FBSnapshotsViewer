//
//  TestLineNumberExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum TestLineNumberExtractorError: Error {
    case unexpectedLogLine(message: String)
}

protocol TestLineNumberExtractor {
    func extractTestLineNumber(from logLine: ApplicationLogLine) throws -> Int
}

class DefaultTestLineNumberExtractor: TestLineNumberExtractor {
    func extractTestLineNumber(from logLine: ApplicationLogLine) throws -> Int {
        guard case let .snapshotTestErrorMessage(line) = logLine else {
            throw TestFilePathExtractorError.unexpectedLogLine(message: "Can not extract test class path from \(logLine). Expected snapshotTestErrorMessage")
        }
        let components = line.components(separatedBy: ":")
        guard components.count > 2, let testLineNumber = Int(components[1]) else {
            throw TestFilePathExtractorError.unexpectedLogLine(message: "Can not extract test line number from \(line). Expected format: Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:27: error: -[FBSnapshotsViewerExampleTests testFail] : ((noErrors) is true) failed - Snapshot comparison failed: Error Domain=FBSnapshotTestControllerErrorDomain Code=4 &amp;quot;Images different&amp;quot; UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=&amp;lt;UIImage: 0x6000000876c0&amp;gt;, {375, 667}, FBReferenceImageKey=&amp;lt;UIImage: 0x60000048e510&amp;gt;, {375, 667}, FBCapturedImageKey=&amp;lt;UIImage: 0x600000085d20&amp;gt;, {375, 667}, NSLocalizedDescription=Images different}")
        }
        return testLineNumber
    }
}
