//
//  FolderWatcher.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa
import SwiftFSWatcher

protocol FolderEventsListenerOutput: class {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive events: [FolderEvent])
}

/// `FolderEventsListener` is responsible to watch folder 
///  changes (new file, updated file, deleted file), watches recursively.
///  It uses the 3rd party dependency under the hood.
final class FolderEventsListener {
    
    /// Internal 3rd party watcher
    fileprivate let watcher: SwiftFSWatcher
    
    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?
    
    init(folderPath: String) {
        watcher = SwiftFSWatcher([folderPath])
    }
}

// MARK: - Interface
extension FolderEventsListener {
    func startListening() {
        watcher.watch { [weak self] events in
            guard let strongSelf = self else {
                return
            }
            let receivedEvents: [FolderEvent] = events.map { FolderEvent(systemEvents: $0.eventFlag.intValue, at: $0.eventPath) }
            strongSelf.output?.folderEventsListener(strongSelf, didReceive: receivedEvents)
        }
    }
    
    func stopListening() {
        watcher.pause()
    }
}
