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

    private func createSnapshotTestResult(fromKaleidoscopeCommandLine line: String, testInformation: SnapshotTestInformation, build: Build) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: "\"")
        guard lineComponents.count == 5 else {
            throw SnapshotTestResultFactoryError.unexpectedKaleidoscopeCommandLineFormat
        }
        let referenceImagePath = lineComponents[1]
        let failedImagePath = lineComponents[3]
        let diffImagePath = failedImagePath.replacingOccurrences(of: "/failed_", with: "/diff_")
        return SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: referenceImagePath, diffImagePath: diffImagePath, failedImagePath: failedImagePath, build: build)
    }

    private func createSnapshotTestInformation(from logLine: ApplicationLogLine, errorLine: ApplicationLogLine) -> SnapshotTestInformation? {
        guard let testNameExtractor = TestNameExtractorFactory().extractor(for: logLine),
            let testClassNameExtractor = TestClassNameExtractorFactory().extractor(for: logLine),
            let testFilePath = try? DefaultTestFilePathExtractor().extractTestClassPath(from: errorLine),
            let testLineNumber = try? DefaultTestLineNumberExtractor().extractTestLineNumber(from: errorLine),
            let testName = try? testNameExtractor.extractTestName(from: logLine),
            let testClassName = try? testClassNameExtractor.extractTestClassName(from: logLine) else {
                return nil
        }
        return SnapshotTestInformation(testClassName: testClassName, testName: testName, testClassPath: testFilePath, testLineNumber: testLineNumber)
    }
    
    private func createSnapshotTestResult(fromSavedReferenceImageLine line: String, testInformation: SnapshotTestInformation, build: Build) throws -> SnapshotTestResult {
        let lineComponents = line.components(separatedBy: ": ")
        guard lineComponents.count == 2 else {
            throw SnapshotTestResultFactoryError.unexpectedSavedReferenceImageLineFormat
        }
        let referenceImagePath = lineComponents[1]
        return SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: referenceImagePath, build: build)
    }

    // MARK: - Interface

    func createSnapshotTestResult(from logLine: ApplicationLogLine, errorLine: ApplicationLogLine, build: Build) -> SnapshotTestResult? {
        guard let testInformation = createSnapshotTestInformation(from: logLine, errorLine: errorLine) else {
            return nil
        }
        switch logLine {
        case .unknown,
             .applicationNameMessage,
             .fbReferenceImageDirMessage,
             .snapshotTestErrorMessage:
            return nil
        case let .kaleidoscopeCommandMessage(line):
            return try? self.createSnapshotTestResult(fromKaleidoscopeCommandLine: line, testInformation: testInformation, build: build)
        case let .referenceImageSavedMessage(line):
            return try? self.createSnapshotTestResult(fromSavedReferenceImageLine: line, testInformation: testInformation, build: build)
        }
    }
}
