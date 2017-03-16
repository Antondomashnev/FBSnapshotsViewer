//
//  FileWatcherFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 16/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// Class is responsible to initialize a new instance of `FileWatcher`
class FileWatcherFactory {
    
    /// Initializes a new `FileWatcher` instance.
    /// It also provides following configuration for `FileWatcher` object
    /// Listening flags: [.UseCFTypes, .FileEvents]
    /// Run loop: RunLoop.current
    /// Latency: 1 second
    ///
    /// - Parameters:
    ///   - paths: array of paths to watch for
    /// - Returns: newly created instance of `FileWatcher` class
    func fileWatcher(for paths: [String]) -> FileWatcher {
        return FileWatcher(paths: paths, createFlag: [.UseCFTypes, .FileEvents], runLoop: RunLoop.current, latency: 1)
    }
}
