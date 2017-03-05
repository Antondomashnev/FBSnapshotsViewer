//
//  FolderEvent.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

enum FolderEventObject: Equatable {
    case folder
    case file
}

extension FolderEventObject: CustomStringConvertible {
    var description: String {
        switch self {
        case .folder:
            return "folder"
        case .file:
            return "file"
        }
    }
}

extension FolderEventObject: CustomDebugStringConvertible {
    var debugDescription: String {
        return self.description
    }
}

//*********************************************************//

enum FolderEvent {
    case modified(path: String, object: FolderEventObject)
    case created(path: String, object: FolderEventObject)
    case deleted(path: String, object: FolderEventObject)
    case renamed(path: String, object: FolderEventObject)
    case unknown

    init(type: FolderEventObject, at path: String, eventFlag: FileWatch.EventFlag) {
        if eventFlag.contains(FileWatch.EventFlag.ItemCreated) {
            self = .created(path: path, object: type)
        }
        else if eventFlag.contains(FileWatch.EventFlag.ItemModified) {
            self = .modified(path: path, object: type)
        }
        else if eventFlag.contains(FileWatch.EventFlag.ItemRemoved) {
            self = .deleted(path: path, object: type)
        }
        else if eventFlag.contains(FileWatch.EventFlag.ItemRenamed) {
            self = .renamed(path: path, object: type)
        }
        else {
            self = .unknown
        }
    }

    init(eventFlag: FileWatch.EventFlag, at path: String) {
        if eventFlag.contains(FileWatch.EventFlag.ItemIsDir) {
            self = FolderEvent(type: .folder, at: path, eventFlag: eventFlag)
        }
        else if eventFlag.contains(FileWatch.EventFlag.ItemIsFile) {
            self = FolderEvent(type: .file, at: path, eventFlag: eventFlag)
        }
        else {
            self = .unknown
        }
    }

    var object: FolderEventObject? {
        switch self {
        case let .modified(_, object):
            return object
        case let .deleted(_, object):
            return object
        case let .renamed(_, object):
            return object
        case let .created(_, object):
            return object
        default:
            return nil
        }
    }

    var path: String? {
        switch self {
        case let .modified(path, _):
            return path
        case let .deleted(path, _):
            return path
        case let .renamed(path, _):
            return path
        case let .created(path, _):
            return path
        default:
            return nil
        }
    }
}

/// Equatable
extension FolderEvent: Equatable {
    public static func == (lhs: FolderEvent, rhs: FolderEvent) -> Bool {
        switch (lhs, rhs) {
        case (let .modified(path1, object1), let .modified(path2, object2)):
            return path1 == path2 && object1 == object2
        case (let .created(path1, object1), let .created(path2, object2)):
            return path1 == path2 && object1 == object2
        case (let .deleted(path1, object1), let .deleted(path2, object2)):
            return path1 == path2 && object1 == object2
        case (let .renamed(path1, object1), let .renamed(path2, object2)):
            return path1 == path2 && object1 == object2
        default: break
        }
        return false
    }
}

extension FolderEvent: CustomStringConvertible {
    var description: String {
        switch self {
        case .created(let path, let object):
            return "FolderEvent: \(object) created at \(path)"
        case .deleted(let path, let object):
            return "FolderEvent: \(object) deleted at \(path)"
        case .modified(let path, let object):
            return "FolderEvent: \(object) modified at \(path)"
        case .renamed(let path, let object):
            return "FolderEvent: \(object) renamed at \(path)"
        case .unknown:
            return "FolderEvent: unknown"
        }
    }
}

extension FolderEvent: CustomDebugStringConvertible {
    var debugDescription: String {
        return self.description
    }
}
