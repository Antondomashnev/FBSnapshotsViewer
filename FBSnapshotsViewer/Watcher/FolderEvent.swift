//
//  FolderEvent.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

enum FolderEventObject {
    case folder
    case file
}

enum FolderEvent {
    case modified(path: String, object: FolderEventObject)
    case created(path: String, object: FolderEventObject)
    case deleted(path: String, object: FolderEventObject)
    case unknown
    
    init(systemEvents: Int, at path: String) {
        switch systemEvents {
        case kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemCreated:
            self = .created(path: path, object: .file)
        case kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemModified:
            self = .modified(path: path, object: .file)
        case kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemRemoved:
            self = .deleted(path: path, object: .file)
        case kFSEventStreamEventFlagItemIsDir + kFSEventStreamEventFlagItemCreated:
            self = .created(path: path, object: .folder)
        case kFSEventStreamEventFlagItemIsDir + kFSEventStreamEventFlagItemModified:
            self = .modified(path: path, object: .folder)
        case kFSEventStreamEventFlagItemIsDir + kFSEventStreamEventFlagItemRemoved:
            self = .deleted(path: path, object: .folder)
        default:
            self = .unknown
        }
    }
}

