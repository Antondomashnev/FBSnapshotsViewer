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

    init(derivedDataFolderPathEditable: Bool, derivedDataFolderPath: String, derivedDataFolderTypeName: String) {
        self.derivedDataFolderPathEditable = derivedDataFolderPathEditable
        self.derivedDataFolderPath = derivedDataFolderPath
        self.derivedDataFolderTypeName = derivedDataFolderTypeName
    }

    init(configuration: Configuration) {
        let derivedDataFolder = configuration.derivedDataFolder
        derivedDataFolderPath = derivedDataFolder.path
        derivedDataFolderTypeName = derivedDataFolder.type.rawValue
        derivedDataFolderPathEditable = derivedDataFolder.type == .xcodeCustom
    }
}
