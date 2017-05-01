//
//  ApplicationLogParser.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// `ApplicationLogReader` class is responsible to read given log files line by line
class ApplicationLogReader {
    // MAKR: - Interface

    /// Reads the given log starting from the given line number
    ///
    /// - Parameters:
    ///   - logText: log text to read
    ///   - lineNumber: starting line number in case developer wants to skip some
    /// - Returns: read array of `ApplicationLogLine`
    func readline(of logText: String, startingFrom lineNumber: Int = 0) -> [ApplicationLogLine] {
        let textLines = logText.components(separatedBy: .newlines)
        if textLines.count <= lineNumber {
            return []
        }
        return textLines[lineNumber...(textLines.count - 1)].map { ApplicationLogLine(line: $0) }
    }
}
