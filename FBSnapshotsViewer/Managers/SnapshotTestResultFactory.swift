//
//  SnapshotTestResultFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum SnapshotTestResultFactoryError: Error {
    case unexpectedKaleidoscopeCommandLineFormat
    case unexpectedSavedReferenceImageLineFormat
}

class SnapshotTestResultFactory {
    // MARK: - Helpers

    private func createSnapshotTestResult(fromKaleidoscopeCommandLine line: String) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: "\"")
        guard lineComponents.count == 5 else {
            throw SnapshotTestResultFactoryError.unexpectedKaleidoscopeCommandLineFormat
        }
        let referenceImagePath = lineComponents[1]
        let failedImagePath = lineComponents[3]
        let diffImagePath = failedImagePath.replacingOccurrences(of: "/failed_", with: "/diff_")
        guard let testName = failedImagePath.components(separatedBy: "/failed_").last?.components(separatedBy: "@").first else {
            throw SnapshotTestResultFactoryError.unexpectedKaleidoscopeCommandLineFormat
        }
        return SnapshotTestResult.failed(testName: testName, referenceImagePath: referenceImagePath, diffImagePath: diffImagePath, failedImagePath: failedImagePath)
    }

    private func createSnapshotTestResult(fromSavedReferenceImageLine line: String) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: ApplicationLogLine.referenceImageSavedMessageIndicatorSubstring)
        guard lineComponents.count == 2 else {
            throw SnapshotTestResultFactoryError.unexpectedSavedReferenceImageLineFormat
        }
        let referenceImagePath = lineComponents[1]
        guard let testName = referenceImagePath.components(separatedBy: "/").last?.components(separatedBy: "@").first else {
            throw SnapshotTestResultFactoryError.unexpectedSavedReferenceImageLineFormat
        }
        return SnapshotTestResult.recorded(testName: testName, referenceImagePath: referenceImagePath)
    }

    // MARK: - Interface

    func createSnapshotTestResult(from logLine: ApplicationLogLine) -> SnapshotTestResult? {
        switch logLine {
        case .unknown:
            return nil
        case let .kaleidoscopeCommandMessage(line):
            return try? self.createSnapshotTestResult(fromKaleidoscopeCommandLine: line)
        case let .referenceImageSavedMessage(line):
            return try? self.createSnapshotTestResult(fromSavedReferenceImageLine: line)
        }
    }
}
