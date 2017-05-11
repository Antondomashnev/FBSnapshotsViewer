//
//  DerivedDataFolder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 23.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct DerivedDataFolder: AutoEquatable {
    let path: String
    let type: DerivedDataFolderType

    /// Default Xcode derived data folder
    static var xcode: DerivedDataFolder {
        return DerivedDataFolder(path: "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData", type: .xcode)
    }
}
