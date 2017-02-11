//
//  RecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import SwiftFSWatcher

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder recursively.
///  It uses the 3rd party dependency under the hood.
final class RecursiveFolderEventsListener: FolderEventsListener {
    /// Underlying listeners for subfolders
    fileprivate var listeners: [String: FolderEventsListener] = [:]
    
    /// Internal 3rd party watcher
    fileprivate let watcher: SwiftFSWatcher
    
    /// Currently watching folder path
    let folderPath: String
    
    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?
    
    init(folderPath: String) {
        self.folderPath = folderPath
        watcher = SwiftFSWatcher([folderPath])
    }
    
    // MARK: - Interface
    
    func startListening() {
        watcher.watch { [weak self] events in
            guard let strongSelf = self else {
                return
            }
            let receivedEvents: [FolderEvent] = events.map { FolderEvent(systemEvents: $0.eventFlag.intValue, at: $0.eventPath) }
            strongSelf.output?.folderEventsListener(strongSelf, didReceive: receivedEvents)
            strongSelf.process(received: receivedEvents)
        }
    }
    
    func stopListening() {
        watcher.pause()
    }
    
    // MARK: - Helpers
    
    func process(received events: [FolderEvent]) {
        for event in events {
            switch event {
            case .created(let path, let object) where object == FolderEventObject.folder:
                let listener = NonRecursiveFolderEventsListener(folderPath: path)
                listener.output = output
                listeners[path] = listener
            case .deleted(let path, let object) where object == FolderEventObject.folder:
                listeners.removeValue(forKey: path)
            default: break
            }
        }
    }
}
