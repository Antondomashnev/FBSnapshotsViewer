//
//  RecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder recursively.
///  It uses the 3rd party dependency under the hood.
final class RecursiveFolderEventsListener: FolderEventsListener {
    /// Internal 3rd party watcher
    fileprivate let watcher: FileWatcher

    /// Applied filters for watched events
    fileprivate let filter: FolderEventFilter?

    /// Underlying listeners for subfolders
    fileprivate var listeners: [String: FolderEventsListener] = [:]

    /// Currently watching folder path
    let folderPath: String

    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?

    /// Internal accessor for private listeners property
    var dependentListeners: [String: FolderEventsListener] {
        let dependentListeners = listeners
        return dependentListeners
    }

    init(folderPath: String, filter: FolderEventFilter? = nil, fileWatcherFactory: FileWatcherFactory = FileWatcherFactory()) {
        self.filter = filter
        self.folderPath = folderPath
        self.watcher = fileWatcherFactory.fileWatcher(for: [folderPath])
    }

    // MARK: - Interface

    func startListening() {
        try? watcher.start { [weak self] event in
            let folderEvent = FolderEvent(eventFlag: event.flag, at: event.path)
            self?.process(received: folderEvent)
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

    // MARK: - Helpers

    private func process(received event: FolderEvent) {
        switch event {
        case .created(let path, let object) where object == FolderEventObject.folder:
            let listener = RecursiveFolderEventsListener(folderPath: path, filter: filter)
            listener.output = output
            listener.startListening()
            listeners[path] = listener
        case .deleted(let path, let object) where object == FolderEventObject.folder:
            listeners.removeValue(forKey: path)
        default: break
        }
    }
}
