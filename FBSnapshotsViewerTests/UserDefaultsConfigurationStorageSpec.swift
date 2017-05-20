//
//  UserDefaultsConfigurationStorageSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class UserDefaultsConfigurationStorageSpec: QuickSpec {
    override func spec() {
        var storage: UserDefaultsConfigurationStorage!
        var userDefaults: UserDefaults!

        beforeEach {
            userDefaults = UserDefaults(suiteName: "UserDefaultsConfigurationStorageSpec")
            storage = UserDefaultsConfigurationStorage(userDefaults: userDefaults)
        }

        afterEach {
            let keys = userDefaults.dictionaryRepresentation().keys
            for key in keys {
                userDefaults.removeObject(forKey: key)
            }
        }

        describe(".loadConfiguration") {
            context("when there is nothing to load") {
                it("returns nil") {
                    expect(storage.loadConfiguration()).to(beNil())
                }
            }

            context("when there is saved configuration") {
                var configuration: FBSnapshotsViewer.Configuration!

                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                    let data: Data! = NSKeyedArchiver.archivedData(withRootObject: configuration)
                    userDefaults.set(data, forKey: storage.configurationKey)
                }

                it("returns configuration") {
                    expect(storage.loadConfiguration()).to(equal(configuration))
                }
            }
        }

        describe(".save") {
            var configuration: FBSnapshotsViewer.Configuration!

            beforeEach {
                configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                storage.save(configuration: configuration)
            }

            it("saves given configuration in user defaults") {
                let data: Data! = userDefaults.object(forKey: storage.configurationKey) as? Data
                let savedConfiguration = NSKeyedUnarchiver.unarchiveObject(with: data) as? FBSnapshotsViewer.Configuration
                expect(savedConfiguration).to(equal(configuration))
            }
        }
    }
}
