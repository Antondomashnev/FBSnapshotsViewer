//
//  ProcessLauncher.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// Class `ProcessLauncher` encapsulates the logic to launch OSX processes
class ProcessLauncher {
    func launchProcess(at launchPath: String, with arguments: [String]? = nil) {
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        process.launch()
    }
}
