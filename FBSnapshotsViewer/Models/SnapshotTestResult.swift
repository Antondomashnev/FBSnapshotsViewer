//
//  SnapshotTestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

struct SnapshotTestInformation: AutoEquatable {
    let testClassName: String
    let testName: String
    let testFilePath: String
    let testLineNumber: Int
}

enum SnapshotTestResult: AutoEquatable {
    var testClassName: String {
        return testInformation.testClassName
    }
    
    var testName: String {
        return testInformation.testName
    }
    
    var testFilePath: String {
        return testInformation.testFilePath
    }
    
    var testLineNumber: Int {
        return testInformation.testLineNumber
    }
    
    var testInformation: SnapshotTestInformation {
        switch self {
        case let .recorded(testInformation, _, _):
            return testInformation
        case let .rejected(testInformation, _, _):
            return testInformation
        case let .failed(testInformation, _, _, _, _):
            return testInformation
        }
    }
    
    var build: Build {
        switch self {
        case let .recorded(_, _, build):
            return build
        case let .rejected(_, _, build):
                return build
        case let .failed(_, _, _, _, build):
            return build
        }
    }

    case recorded(testInformation: SnapshotTestInformation,
                  referenceImagePath: String,
                  build: Build)

    case rejected(testInformation: SnapshotTestInformation,
        referenceImagePath: String,
        build: Build)
    
    case failed(testInformation: SnapshotTestInformation,
                referenceImagePath: String,
                diffImagePath: String,
                failedImagePath: String,
                build: Build)
}
