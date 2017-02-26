//
//  TestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

struct TestResult {
    let referenceImageURL: URL
    let diffImageURL: URL
    let failedImageURL: URL
    let testName: String
}
