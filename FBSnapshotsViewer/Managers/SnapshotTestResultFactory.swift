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

    private func extractTestName(fromFailedImage path: String) throws -> String {
        let pathComponents = path.components(separatedBy: "/")
        guard pathComponents.count >= 2,
              let testName = pathComponents.last?.components(separatedBy: "failed_").last?.components(separatedBy: "@").first,
              !testName.isEmpty else {
            throw SnapshotTestResultFactoryError.unexpectedKaleidoscopeCommandLineFormat
        }
        let testClassName = pathComponents[pathComponents.count - 2]
        return "\(testClassName) \(testName)"
    }

    private func extractTestName(fromSavedReferenceImage path: String) throws -> String {
        let pathComponents = path.components(separatedBy: "/")
        guard pathComponents.count >= 2,
              let testName = pathComponents.last?.components(separatedBy: "@").first,
              !testName.contains(".png") else {
            throw SnapshotTestResultFactoryError.unexpectedSavedReferenceImageLineFormat
        }
        let testClassName = pathComponents[pathComponents.count - 2]
        return "\(testClassName) \(testName)"
    }

    private func createSnapshotTestResult(fromKaleidoscopeCommandLine line: String, build: Build) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: "\"")
        guard lineComponents.count == 5 else {
            throw SnapshotTestResultFactoryError.unexpectedKaleidoscopeCommandLineFormat
        }
        let referenceImagePath = lineComponents[1]
        let failedImagePath = lineComponents[3]
        let diffImagePath = failedImagePath.replacingOccurrences(of: "/failed_", with: "/diff_")
        let testName = try extractTestName(fromFailedImage: failedImagePath)
        return SnapshotTestResult.failed(testName: testName, referenceImagePath: referenceImagePath, diffImagePath: diffImagePath, failedImagePath: failedImagePath, build: build)
    }

    private func createSnapshotTestResult(fromSavedReferenceImageLine line: String, build: Build) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: ": ")
        guard lineComponents.count == 2 else {
            throw SnapshotTestResultFactoryError.unexpectedSavedReferenceImageLineFormat
        }
        let referenceImagePath = lineComponents[1]
        let testName = try extractTestName(fromSavedReferenceImage: referenceImagePath)
        return SnapshotTestResult.recorded(testName: testName, referenceImagePath: referenceImagePath, build: build)
    }

    // MARK: - Interface

    func createSnapshotTestResult(from logLine: ApplicationLogLine, build: Build) -> SnapshotTestResult? {
        switch logLine {
        case .unknown,
             .applicationNameMessage,
             .fbReferenceImageDirMessage:
            return nil
        case let .kaleidoscopeCommandMessage(line):
            return try? self.createSnapshotTestResult(fromKaleidoscopeCommandLine: line, build: build)
        case let .referenceImageSavedMessage(line):
            return try? self.createSnapshotTestResult(fromSavedReferenceImageLine: line, build: build)
        }
    }
}
