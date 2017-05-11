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
    private let configurationKey: String = "com.antondomashnev.FBSnapshotsViewer.UserDefaultsConfigurationStorage.Configuration"

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - ConfigurationStorage

    func save(configuration: Configuration) {

    }

    func loadConfiguration() -> Configuration? {
        guard let userDefaults.object(forKey: configurationKey) as? Configuration else {
            return nil
        }
    }
}
