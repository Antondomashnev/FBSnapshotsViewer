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
        case let .recorded(testName, _, _, _):
            return testName
        case let .failed(testName, _, _, _, _, _):
            return testName
        }
    }

    var createdAt: Date {
        switch self {
        case let .recorded(_, _, createdAt, _):
            return createdAt
        case let .failed(_, _, _, _, createdAt, _):
            return createdAt
        }
    }

    var applicationName: String {
        switch self {
        case let .recorded(_, _, _, applicationNamw):
            return applicationNamw
        case let .failed(_, _, _, _, _, applicationName):
            return applicationName
        }
    }

    case recorded(testName: String,
                  referenceImagePath: String,
                  createdAt: Date,
                  applicationName: String)

    case failed(testName: String,
                referenceImagePath: String,
                diffImagePath: String,
                failedImagePath: String,
                createdAt: Date,
                applicationName: String)
}
