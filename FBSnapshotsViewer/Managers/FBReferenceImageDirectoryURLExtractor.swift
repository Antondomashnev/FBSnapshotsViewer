//
//  FBReferenceImageDirectoryURLExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum FBReferenceImageDirectoryURLExtractorError: Error {
    case unexpectedLogLine(message: String)
}

protocol FBReferenceImageDirectoryURLExtractor: AutoMockable {
    func extractImageDirectoryURLs(from logLine: ApplicationLogLine) throws -> [URL]
}

class FBReferenceImageDirectoryURLExtractorFactory {
    func fbReferenceImageDirectoryURLExtractor(for configuration: Configuration) -> FBReferenceImageDirectoryURLExtractor {
        switch configuration.derivedDataFolder {
        case .xcodeCustom,
             .xcodeDefault:
            return XcodeFBReferenceImageDirectoryURLExtractor()
        case .appcode:
            return AppCodeFBReferenceImageDirectoryURLExtractor()
        }
    }
}

class FBReferenceImageDirectoryURLExtractorHelper {
    private static func buildReferenceImagePathURLs(with path: String) -> [URL] {
        // There are two possible directories for one ENV variable:
        // path + "_64" suffix if it's generated with FBSnapshotTestCase
        // path without suffix if it's generated with Nimble-Snapshots
        return [URL(fileURLWithPath: path + "_64", isDirectory: true),
                URL(fileURLWithPath: path, isDirectory: true)]
    }
    
    private static func extractLine(from logLine: ApplicationLogLine) throws -> String {
        guard case let .fbReferenceImageDirMessage(line) = logLine,
            line.contains("/") else {
                throw FBReferenceImageDirectoryURLExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected .fbReferenceImageDirMessage")
        }
        return line
    }
    
    static func extractImageDirectoryURLs(from logLine: ApplicationLogLine, componentsBuilder: (String) -> [String]?, expectedLogLineExample: String) throws -> [URL] {
        let line = try extractLine(from: logLine)
        guard let components = componentsBuilder(line), components.count == 3 else {
            throw FBReferenceImageDirectoryURLExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected the following format: \(expectedLogLineExample)")
        }
        return buildReferenceImagePathURLs(with: components[1])
    }
}

class XcodeFBReferenceImageDirectoryURLExtractor: FBReferenceImageDirectoryURLExtractor {
    func extractImageDirectoryURLs(from logLine: ApplicationLogLine) throws -> [URL] {
        let componentsBuilder: (String) -> [String]? = { $0.components(separatedBy: " = ").last?.components(separatedBy: "\"") }
        return try FBReferenceImageDirectoryURLExtractorHelper.extractImageDirectoryURLs(from: logLine, componentsBuilder: componentsBuilder, expectedLogLineExample: "\"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\";")
    }
}

class AppCodeFBReferenceImageDirectoryURLExtractor: FBReferenceImageDirectoryURLExtractor {
    func extractImageDirectoryURLs(from logLine: ApplicationLogLine) throws -> [URL] {
        let componentsBuilder: (String) -> [String]? = { $0.components(separatedBy: "value=").last?.components(separatedBy: "\"") }
        return try FBReferenceImageDirectoryURLExtractorHelper.extractImageDirectoryURLs(from: logLine, componentsBuilder: componentsBuilder, expectedLogLineExample: "<env name=\"FB_REFERENCE_IMAGE_DIR\" value=\"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\"/>")
    }
}
