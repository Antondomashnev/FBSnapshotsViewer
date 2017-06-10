//
//  SnapshotTestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

enum SnapshotTestResult: AutoEquatable {
    var testName: String {
        switch self {
        case let .recorded(testName, _, _):
            return testName
        case let .failed(testName, _, _, _, _):
            return testName
        }
    }

    var build: Build {
        switch self {
        case let .recorded(_, _, build):
            return build
        case let .failed(_, _, _, _, build):
            return build
        }
    }

    case recorded(testName: String,
                  referenceImagePath: String,
                  build: Build)

    case failed(testName: String,
                referenceImagePath: String,
                diffImagePath: String,
                failedImagePath: String,
                build: Build)
}
