//
//  ApplicationLogParser.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class ApplicationLogParser {
    private let kaleidoscopeDiffCommandMessage = "ksdiff"
    private let referenceImageSavedMessage = "Reference image save at:"

    // MAKR: - Interface

    func parse(log logText: String) -> [SnapshotTestResult] {
        var results: [SnapshotTestResult] = []
        let lines = logText.components(separatedBy: .newlines)
        for line in lines {

        }
        return results
    }
}
