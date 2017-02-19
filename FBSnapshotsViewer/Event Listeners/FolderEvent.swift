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
        switch self {
        case .folder:
            return "folder"
        case .file:
            return "file"
        }
    }
}

//*********************************************************//

enum FolderEvent {
    case modified(path: String, object: FolderEventObject)
    case created(path: String, object: FolderEventObject)
    case deleted(path: String, object: FolderEventObject)
    case unknown
    
    init(eventFlag: FileWatch.EventFlag, at path: String) {
        if eventFlag == FileWatch.EventFlag.ItemIsDir.union(FileWatch.EventFlag.ItemCreated) {
            self = .created(path: path, object: .folder)
        }
        else if eventFlag == FileWatch.EventFlag.ItemIsDir.union(FileWatch.EventFlag.ItemModified) {
            self = .modified(path: path, object: .folder)
        }
        else if eventFlag == FileWatch.EventFlag.ItemIsDir.union(FileWatch.EventFlag.ItemRemoved) {
            self = .deleted(path: path, object: .folder)
        }
        else if eventFlag == FileWatch.EventFlag.ItemIsFile.union(FileWatch.EventFlag.ItemCreated) {
            self = .created(path: path, object: .file)
        }
        else if eventFlag == FileWatch.EventFlag.ItemIsFile.union(FileWatch.EventFlag.ItemModified) {
            self = .modified(path: path, object: .file)
        }
        else if eventFlag == FileWatch.EventFlag.ItemIsFile.union(FileWatch.EventFlag.ItemRemoved) {
            self = .deleted(path: path, object: .file)
        }
        else {
            self = .unknown
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
        case .unknown:
            return "FolderEvent: unknown"
        }
    }
}

extension FolderEvent: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .created(let path, let object):
            return "FolderEvent: \(object) created at \(path)"
        case .deleted(let path, let object):
            return "FolderEvent: \(object) deleted at \(path)"
        case .modified(let path, let object):
            return "FolderEvent: \(object) modified at \(path)"
        case .unknown:
            return "FolderEvent: unknown"
        }
    }
}
