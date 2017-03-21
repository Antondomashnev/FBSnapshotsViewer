//
//  NonRecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder non-recursively.
///  It uses the 3rd party dependency under the hood.
final class NonRecursiveFolderEventsListener: FolderEventsListener {

    /// Internal 3rd party watcher
    fileprivate let watcher: FileWatcher

    /// Applied filter for watched events
    fileprivate let filter: FolderEventFilter?

    /// Currently watching folder path
    let folderPath: String

    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?

    init(folderPath: String, filter: FolderEventFilter? = nil, fileWatcherFactory: FileWatcherFactory = FileWatcherFactory()) {
        self.filter = filter
        self.folderPath = folderPath
        self.watcher = fileWatcherFactory.fileWatcher(for: [folderPath])
    }

    func startListening() {
        try? watcher.start { [weak self] event in
            let folderEvent = FolderEvent(eventFlag: event.flag, at: event.path)
            if let existedFilter = self?.filter, !existedFilter.apply(to: folderEvent) {
                return
            }
            if let strongSelf = self {
                strongSelf.output?.folderEventsListener(strongSelf, didReceive: folderEvent)
            }
        }

    }

    func stopListening() {
        watcher.stop()
    }
}
