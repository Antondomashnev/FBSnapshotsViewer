//
//  AppConstants.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// Main idea is taken from OSS Mozilla Firefox app
struct AppProcessInfo {
    static let IsRunningTest = NSClassFromString("XCTestCase") != nil
}
