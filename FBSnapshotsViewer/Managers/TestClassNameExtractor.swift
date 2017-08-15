//
//  TestClassNameExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 15.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum TestClassNameExtractorError: Error {
    case unexpectedLogLine(message: String)
}

protocol TestClassNameExtractor: AutoMockable {
    func extractTestClassName(from logLine: ApplicationLogLine) throws -> String
}

class TestClassNameExtractorFactory {
    func TestClassNameExtractor(for logLine: ApplicationLogLine) -> TestClassNameExtractor? {
        switch logLine {
        case .kaleidoscopeCommandMessage:
            return FailedTestClassNameExtractor()
        case .referenceImageSavedMessage:
            return RecordedTestClassNameExtractor()
        default:
            return nil
        }
    }
}

fileprivate class TestClassNameExtractorHelper {
    static func extractTestClassName(from imagePath: String) -> String? {
        let pathComponents = imagePath.components(separatedBy: "/")
        return pathComponents.count >= 2 ? pathComponents[pathComponents.count - 1] : nil
    }
}

class FailedTestClassNameExtractor: TestClassNameExtractor {
    func extractTestClassName(from logLine: ApplicationLogLine) throws -> String {
        guard case let ApplicationLogLine.kaleidoscopeCommandMessage(line) = logLine else {
            throw TestClassNameExtractorError.unexpectedLogLine(message: "Unexpected \(logLine). Expected kaleidoscopeCommandMessage")
        }
        let lineComponents = line.components(separatedBy: "\"")
        guard lineComponents.count >= 2,
            let testClassName = TestClassNameExtractorHelper.extractTestClassName(from: lineComponents[1].replacingOccurrences(of: "reference_", with: "")) else {
                throw TestClassNameExtractorError.unexpectedLogLine(message: "Unexpected \(line). Expected ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\"")
        }
        return testClassName
    }
}

class RecordedTestClassNameExtractor: TestClassNameExtractor {
    func extractTestClassName(from logLine: ApplicationLogLine) throws -> String {
        guard case let ApplicationLogLine.referenceImageSavedMessage(line) = logLine else {
            throw TestClassNameExtractorError.unexpectedLogLine(message: "Unexpected \(logLine). Expected referenceImageSavedMessage")
        }
        let lineComponents = line.components(separatedBy: ": ")
        guard lineComponents.count >= 2,
            let testClassName = TestClassNameExtractorHelper.extractTestClassName(from: lineComponents[1]) else {
                throw TestClassNameExtractorError.unexpectedLogLine(message: "Unexpected \(line). Expected 2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
        }
        return testClassName
    }
}
