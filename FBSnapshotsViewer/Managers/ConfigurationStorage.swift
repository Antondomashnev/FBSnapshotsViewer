//
//  ConfigurationStorage.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol ConfigurationStorage: AutoMockable {
    func loadConfiguration() -> Configuration?
    func save(configuration: Configuration)
}

class UserDefaultsConfigurationStorage: ConfigurationStorage {
    private let userDefaults: UserDefaults
    let configurationKey: String = "com.antondomashnev.FBSnapshotsViewer.UserDefaultsConfigurationStorage.Configuration"

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - ConfigurationStorage

    func save(configuration: Configuration) {
        let archivedConfiguration = NSKeyedArchiver.archivedData(withRootObject: configuration)
        userDefaults.setValue(archivedConfiguration, forKey: configurationKey)
    }

    func loadConfiguration() -> Configuration? {
        guard let archivedConfiguration = userDefaults.object(forKey: configurationKey) as? Data,
              let configuration = NSKeyedUnarchiver.unarchiveObject(with: archivedConfiguration) as? Configuration else {
            return nil
        }
        return configuration
    }
}
