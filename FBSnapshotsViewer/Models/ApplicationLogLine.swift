//
//  ApplicationLogLine.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class ApplicationLogLineIndicatorContainer {
    func kaleidoscopeCommandMessageIndicator(for configuration: Configuration) -> String {
        return ""
    }

    func referenceImageSavedMessageIndicator(for configuration) -> String {
        return ""
    }

    func kaleidoscopeCommandMessageIndicator(for configuration) -> String {
        return ""
    }
}

enum ApplicationLogLine: AutoEquatable, AutoHashable {
    static let kaleidoscopeCommandMessageIndicatorSubstring = "ksdiff "
    static let referenceImageSavedMessageIndicatorSubstring = "Reference image save at: "
    static let applicationNameMessageIndicatorSubstring = "XCInjectBundleInto"

    case kaleidoscopeCommandMessage(line: String)
    case referenceImageSavedMessage(line: String)
    case applicationNameMessage(line: String)
    case unknown

    init(line: String, configuration: Configuration = Configuration.default()) {
        if line.contains(ApplicationLogLine.kaleidoscopeCommandMessageIndicatorSubstring) {
            self = ApplicationLogLine.kaleidoscopeCommandMessage(line: line)
        }
        else if line.contains(ApplicationLogLine.referenceImageSavedMessageIndicatorSubstring) {
            self = ApplicationLogLine.referenceImageSavedMessage(line: line)
        }
        else if line.contains(ApplicationLogLine.applicationNameMessageIndicatorSubstring) {
            self = ApplicationLogLine.applicationNameMessage(line: line)
        }
        else {
            self = ApplicationLogLine.unknown
        }
    }
}
