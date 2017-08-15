//
//  TestNameExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 15.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum TestNameExtractorError: Error {
    case unexpectedLogLine(message: String)
}

protocol TestNameExtractor: AutoMockable {
    func extractTestName(from logLine: ApplicationLogLine) throws -> String
}

class TestNameExtractorFactory {
    func extractor(for logLine: ApplicationLogLine) -> TestNameExtractor? {
        switch logLine {
        case .kaleidoscopeCommandMessage:
            return FailedTestNameExtractor()
        case .referenceImageSavedMessage:
            return RecordedTestNameExtractor()
        default:
            return nil
        }
    }
}

class TestNameExtractorHelper {
    static func extractTestName(from imagePath: String) -> String? {
        return imagePath.components(separatedBy: "/").last?.components(separatedBy: "@").first
    }
}

class FailedTestNameExtractor: TestNameExtractor {
    func extractTestName(from logLine: ApplicationLogLine) throws -> String {
        guard case let ApplicationLogLine.kaleidoscopeCommandMessage(line) = logLine else {
            throw TestNameExtractorError.unexpectedLogLine(message: "Unexpected \(logLine). Expected kaleidoscopeCommandMessage")
        }
        let lineComponents = line.components(separatedBy: "\"")
        guard lineComponents.count >= 2,
              let testName = TestNameExtractorHelper.extractTestName(from: lineComponents[1].replacingOccurrences(of: "reference_", with: "")) else {
            throw TestNameExtractorError.unexpectedLogLine(message: "Unexpected \(line). Expected ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\"")
        }
        return testName
    }
}

class RecordedTestNameExtractor: TestNameExtractor {
    func extractTestName(from logLine: ApplicationLogLine) throws -> String {
        guard case let ApplicationLogLine.referenceImageSavedMessage(line) = logLine else {
            throw TestNameExtractorError.unexpectedLogLine(message: "Unexpected \(logLine). Expected referenceImageSavedMessage")
        }
        let lineComponents = line.components(separatedBy: ": ")
        guard lineComponents.count >= 2,
              let testName = TestNameExtractorHelper.extractTestName(from: lineComponents[1]) else {
                throw TestNameExtractorError.unexpectedLogLine(message: "Unexpected \(line). Expected 2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
        }
        return testName
    }
}
