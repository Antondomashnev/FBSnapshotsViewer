//
//  ApplicationNameExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum ApplicationNameExtractorError: Error {
    case unexpectedLogLine(message: String)
}

protocol ApplicationNameExtractor: AutoMockable {
    func extractApplicationName(from logLine: ApplicationLogLine) throws -> String
}

class ApplicationNameExtractorFactory {
    func applicationNameExtractor(for configuration: Configuration) -> ApplicationNameExtractor {
        switch configuration.derivedDataFolder {
        case .xcodeCustom,
             .xcodeDefault:
            return XcodeApplicationNameExtractor()
        case .appcode:
            return AppCodeApplicationNameExtractor()
        }
    }
}

class XcodeApplicationNameExtractor: ApplicationNameExtractor {
    func extractApplicationName(from logLine: ApplicationLogLine) throws -> String {
        guard case let .applicationNameMessage(line) = logLine else {
            throw ApplicationNameExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected .applicationNameMessage")
        }
        guard line.contains("/"),
              let applicationName = line.components(separatedBy: "/").last?.components(separatedBy: "\"").first else {
            throw ApplicationNameExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected the following format: XCInjectBundleInto = \"/Users/antondomashnev/Library/Developer/Xcode/DerivedData/FBSnapshotsViewerExample-eeuapqepwoebslcfqojhfzyfuhmp/Build/Products/Debug-iphonesimulator/FBSnapshotsViewerExample.app/FBSnapshotsViewerExample\";")
        }
        return applicationName
    }
}

class AppCodeApplicationNameExtractor: ApplicationNameExtractor {
    func extractApplicationName(from logLine: ApplicationLogLine) throws -> String {
        guard case let .applicationNameMessage(line) = logLine else {
            throw ApplicationNameExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected .applicationNameMessage")
        }
        let lineComponents = line.components(separatedBy: " ")
        guard lineComponents.count == 11,
              let applicationName = lineComponents[2].components(separatedBy: "\"").filter({ !$0.isEmpty }).last else {
            throw ApplicationNameExtractorError.unexpectedLogLine(message: "Unexpected log line given: \(logLine). Expected the following format: <config PASS_PARENT_ENVS_2=\"true\" PROJECT_NAME=\"FBSnapshotsViewerExample\" TARGET_NAME=\"FBSnapshotsViewerExampleTests\" CONFIG_NAME=\"Debug\" SCHEME_NAME=\"FBSnapshotsViewerExampleTests\" TEST_MODE=\"SUITE_TEST\" XCODE_SKIPPED_TESTS_HASH_CODE=\"0\" configId=\"OCUnitRunConfiguration\" name=\"FBSnapshotsViewerExampleTests\" target=\"iphonesimulatoriPhone_7_10.3_x86_64_1\">")
        }
        return applicationName
    }
}
