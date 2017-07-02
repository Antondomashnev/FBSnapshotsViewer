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
    func extractImageDirectoryURL(from logLine: ApplicationLogLine) throws -> URL
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

class BaseFBReferenceImageDirectoryURLExtractor {
    fileprivate func extractLine(from logLine: ApplicationLogLine) throws -> String {
        guard case let .fbReferenceImageDirMessage(line) = logLine,
              line.contains("/") else {
            throw FBReferenceImageDirectoryURLExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected .fbReferenceImageDirMessage")
        }
        return line
    }
    
    fileprivate func buildReferenceImagePathURL(with path: String) -> URL {
        // ios-snapshots adds a suffix for the reference dir depending on the acrhitecture. For now we support only 64 bit
        return URL(fileURLWithPath: path + "_64", isDirectory: true)
    }
}

class XcodeFBReferenceImageDirectoryURLExtractor: BaseFBReferenceImageDirectoryURLExtractor, FBReferenceImageDirectoryURLExtractor {
    func extractImageDirectoryURL(from logLine: ApplicationLogLine) throws -> URL {
        let line = try extractLine(from: logLine)
        guard let components = line.components(separatedBy: " = ").last?.components(separatedBy: "\""),
              components.count == 3 else {
                throw FBReferenceImageDirectoryURLExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected the following format: \"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\";")
        }
        return buildReferenceImagePathURL(with: components[1])
    }
}

class AppCodeFBReferenceImageDirectoryURLExtractor: BaseFBReferenceImageDirectoryURLExtractor, FBReferenceImageDirectoryURLExtractor {
    func extractImageDirectoryURL(from logLine: ApplicationLogLine) throws -> URL {
        let line = try extractLine(from: logLine)
        guard let components = line.components(separatedBy: "value=").last?.components(separatedBy: "\""),
              components.count == 3 else {
                throw FBReferenceImageDirectoryURLExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected the following format: <env name=\"FB_REFERENCE_IMAGE_DIR\" value=\"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\"/>")
        }
        return buildReferenceImagePathURL(with: components[1])
    }
}
