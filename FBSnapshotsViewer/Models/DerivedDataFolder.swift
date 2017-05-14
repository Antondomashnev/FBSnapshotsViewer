//
//  DerivedDataFolder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 23.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum DerivedDataFolder: AutoEquatable {
    var type: DerivedDataFolderType {
        switch self {
        case .xcode:
            return DerivedDataFolderType.xcode
        case .custom(_):
            return DerivedDataFolderType.custom
        }
    }

    var path: String {
        switch self {
        case .xcode:
            return "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
        case let .custom(path):
            return path
        }
    }

    case custom(path: String)
    case xcode
}
