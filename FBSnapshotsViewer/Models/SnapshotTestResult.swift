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

    var createdAt: Date {
        switch self {
        case let .recorded(_, _, createdAt):
            return createdAt
        case let .failed(_, _, _, _, createdAt):
            return createdAt
        }
    }

    case recorded(testName: String,
                  referenceImagePath: String,
                  createdAt: Date)

    case failed(testName: String,
                referenceImagePath: String,
                diffImagePath: String,
                failedImagePath: String,
                createdAt: Date)
}
