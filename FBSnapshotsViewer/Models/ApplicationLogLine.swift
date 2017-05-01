//
//  ApplicationLogLine.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum ApplicationLogLine: AutoEquatable, AutoHashable {
    static let kaleidoscopeCommandMessageIndicatorSubstring = "ksdiff "
    static let referenceImageSavedMessageIndicatorSubstring = "Reference image save at: "

    case kaleidoscopeCommandMessage(line: String)
    case referenceImageSavedMessage(line: String)
    case unknown

    init(line: String) {
        if line.contains(ApplicationLogLine.kaleidoscopeCommandMessageIndicatorSubstring) {
            self = ApplicationLogLine.kaleidoscopeCommandMessage(line: line)
        }
        else if line.contains(ApplicationLogLine.referenceImageSavedMessageIndicatorSubstring) {
            self = ApplicationLogLine.referenceImageSavedMessage(line: line)
        }
        else {
            self = ApplicationLogLine.unknown
        }
    }
}
