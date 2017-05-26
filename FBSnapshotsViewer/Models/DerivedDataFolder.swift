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
        case .xcodeDefault:
            return DerivedDataFolderType.xcodeDefault
        case .xcodeCustom:
            return DerivedDataFolderType.xcodeCustom
        case .appcode:
            return DerivedDataFolderType.appcode
        }
    }

    var path: String {
        switch self {
        case .xcodeDefault:
            return "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData"
        case let .xcodeCustom(path):
            return path
        case let .appcode(path):
            return path
        }
    }

    case xcodeCustom(path: String)
    case xcodeDefault
    case appcode(path: String)
}
