//
//  PreferencesDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct PreferencesDisplayInfo {
    let derivedDataFolderPathEditable: Bool
    let derivedDataFolderPath: String
    let derivedDataFolderTypeName: String
    let derivedDataFolderTypeNames: [String] = DerivedDataFolderType.allCases.map { $0.rawValue }

    init(derivedDataFolder: DerivedDataFolder) {
        derivedDataFolderPath = derivedDataFolder.path
        derivedDataFolderTypeName = derivedDataFolder.type.rawValue
        derivedDataFolderPathEditable = derivedDataFolder.type == .custom
    }
}
