//
//  PreferencesDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct PreferencesDisplayInfo {
    let pathExplanation: String
    let derivedDataFolderPathEditable: Bool
    let derivedDataFolderPath: String
    let derivedDataFolderTypeName: String
    let referenceImagesFolderPath: String
    let derivedDataFolderTypeNames: [String] = DerivedDataFolderType.allCases.map { $0.rawValue }

  init(derivedDataFolderPathEditable: Bool, derivedDataFolderPath: String, derivedDataFolderTypeName: String, pathExplanation: String, referenceImagesFolderPath: String) {
        self.derivedDataFolderPathEditable = derivedDataFolderPathEditable
        self.derivedDataFolderPath = derivedDataFolderPath
        self.derivedDataFolderTypeName = derivedDataFolderTypeName
        self.pathExplanation = pathExplanation
        self.referenceImagesFolderPath = referenceImagesFolderPath
    }

    init(configuration: Configuration) {
        let derivedDataFolder = configuration.derivedDataFolder
        derivedDataFolderPath = derivedDataFolder.path
        derivedDataFolderTypeName = derivedDataFolder.type.rawValue
        referenceImagesFolderPath = configuration.referenceImagesFolder
        switch derivedDataFolder.type {
        case .xcodeCustom:
            derivedDataFolderPathEditable = true
            pathExplanation = "Please specify the path to the Derived Data folder that you set in Xcode preferences."
        case .xcodeDefault:
            derivedDataFolderPathEditable = false
            pathExplanation = "The path is automatically set to ~/Library/Developer/Xcode/DerivedData."
        case .appcode:
            derivedDataFolderPathEditable = true
            pathExplanation = "Please specify the path to the AppCode cache folder. By default it's under ~/Library/Caches/AppCode${APP_CODE_VERSION_INFO}."
        }
    }
}
