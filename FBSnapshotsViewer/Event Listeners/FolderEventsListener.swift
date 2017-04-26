//
//  FolderWatcher.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol FolderEventsListenerOutput: class, AutoMockable {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent)
}

protocol FolderEventsListener: AutoMockable {

    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput? { get set }

    /// Designated initializer to create new instance of FolderEventsListener
    ///
    /// - Parameter folderPath: absolute folder path to watch
    /// - Parameter filter: filter for received event
    /// - Parameter fileWatcherFactory: factory to create underlying watcher
    init(folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory)

    /// Starts listening for events
    func startListening()

    /// Stops listening for events
    func stopListening()
}
