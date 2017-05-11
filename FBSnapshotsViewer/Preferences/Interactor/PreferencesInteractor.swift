//
//  PreferencesInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class PreferencesInteractor {
    fileprivate let configurationStorage: ConfigurationStorage
    fileprivate var configuration: Configuration

    init(configurationStorage: ConfigurationStorage) {
        guard let configuration = configurationStorage.loadConfiguration() else {
            preconditionFailure("At the moment of loading current configuration it must exist in the storage")
        }
        self.configurationStorage = configurationStorage
        self.configuration = configuration
    }
}

extension PreferencesInteractor: PreferencesInteractorInput {
    // MARK: - PreferencesInteractorInput

    func setNewDerivedDataFolderType(_ type: String) {
        guard let derivedDataFolderType = DerivedDataFolderType(rawValue: type) else {
            preconditionFailure("Unexpected derivedDataFolderType received: \(type)")
        }
        if derivedDataFolderType == configuration.derivedDataFolder.type {
            return
        }
        switch derivedDataFolderType {
        case .xcode:
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcode)
        case .custom:
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: ""))
        }
    }

    func setNewDerivedDataFolderPath(_ path: String) {
        switch configuration.derivedDataFolder.type {
        case .xcode:
            assertionFailure("Unexpected call to modify derived data folder path while the type of derived data is Xcode")
            break
        case .custom(_):
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: path))
        }
    }

    func currentConfiguration() -> Configuration {
        return configuration
    }

    func save() {
        configurationStorage.save(configuration: configuration)
    }
}
