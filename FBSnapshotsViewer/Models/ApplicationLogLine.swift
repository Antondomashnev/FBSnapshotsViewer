//
//  ApplicationLogLine.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct ApplicationLogLineIndicatorContainer {
    static func kaleidoscopeCommandMessageIndicator(for configuration: Configuration) -> String {
        return "ksdiff "
    }

    static func referenceImageSavedMessageIndicator(for configuration: Configuration = Configuration.default()) -> String {
        return "Reference image save at: "
    }

    static func applicationNameMessageIndicator(for configuration: Configuration = Configuration.default()) -> String {
        switch configuration.derivedDataFolder {
        case .xcodeDefault,
             .xcodeCustom:
            return "XCInjectBundleInto"
        case .appcode:
            return "PROJECT_NAME="
        }
    }
    
    static func fbReferenceImageDirMessageIndicator(for configuration: Configuration = Configuration.default()) -> String {
        return "FB_REFERENCE_IMAGE_DIR"
    }

    static func snapshotTestErrorMessageIndicators(for configuration: Configuration) -> [String] {
        return [" : ((noErrors) is true) failed - Snapshot comparison failed",
                " : failed - Snapshot comparison failed: Optional(Error Domain=FBSnapshotTestControllerErrorDomain Code=4",
                " : failed - No previous reference image. New image has been stored for approval.",
                " : failed - Test ran in record mode."]
    }
}

enum ApplicationLogLine: AutoEquatable, AutoHashable {
    static let fbReferenceImageDirMessageIndicatorSubstring = "FB_REFERENCE_IMAGE_DIR"

    case kaleidoscopeCommandMessage(line: String)
    case referenceImageSavedMessage(line: String)
    case applicationNameMessage(line: String)
    case fbReferenceImageDirMessage(line: String)
    case snapshotTestErrorMessage(line: String)
    case unknown

    init(line: String, configuration: Configuration = Configuration.default()) {
        if line.contains(ApplicationLogLineIndicatorContainer.kaleidoscopeCommandMessageIndicator(for: configuration)) {
            self = ApplicationLogLine.kaleidoscopeCommandMessage(line: line)
        }
        else if line.contains(ApplicationLogLineIndicatorContainer.referenceImageSavedMessageIndicator(for: configuration)) {
            self = ApplicationLogLine.referenceImageSavedMessage(line: line)
        }
        else if line.contains(ApplicationLogLineIndicatorContainer.applicationNameMessageIndicator(for: configuration)) {
            self = ApplicationLogLine.applicationNameMessage(line: line)
        }
        else if line.contains(ApplicationLogLineIndicatorContainer.fbReferenceImageDirMessageIndicator(for: configuration)) {
            self = ApplicationLogLine.fbReferenceImageDirMessage(line: line)
        }
        else if ApplicationLogLineIndicatorContainer.snapshotTestErrorMessageIndicators(for: configuration).reduce(false, { initial, next in initial ? true : line.contains(next) }) {
            self = ApplicationLogLine.snapshotTestErrorMessage(line: line)
        }
        else {
            self = ApplicationLogLine.unknown
        }
    }
}
