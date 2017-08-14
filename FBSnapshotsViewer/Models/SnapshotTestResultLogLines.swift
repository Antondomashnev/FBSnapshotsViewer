//
//  SnapshotTestResultLogLines.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum SnapshotTestResultLogLines {
    var resultMessage: String {
        switch self {
        case let .failedSnapshotTestResultLines(resultMessage, _):
            return resultMessage
        case let .recordedSnapshotTestResultLines(resultMessage, _):
            return resultMessage
        }
    }

    var errorMessage: String {
        switch self {
        case let .failedSnapshotTestResultLines(_, errorMessage):
            return errorMessage
        case let .recordedSnapshotTestResultLines(_, errorMessage):
            return errorMessage
        }
    }

    init?(resultLogLine: ApplicationLogLine, errorLogLine: ApplicationLogLine) {
        guard case let ApplicationLogLine.snapshotTestErrorMessage(errorMessage) = errorLogLine else {
            return nil
        }
        switch resultLogLine {
        case let .kaleidoscopeCommandMessage(resultMessage):
            self = .failedSnapshotTestResultLines(resultMessage: resultMessage, errorMessage: errorMessage)
        case let .referenceImageSavedMessage(resultMessage):
            self = .recordedSnapshotTestResultLines(resultMessage: resultMessage, errorMessage: errorMessage)
        default:
            return nil
        }
    }

    case recordedSnapshotTestResultLines(resultMessage: String, errorMessage: String)
    case failedSnapshotTestResultLines(resultMessage: String, errorMessage: String)
}
