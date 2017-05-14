//
//  PreferencesInteractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class PreferencesInteractorSpec: QuickSpec {
    override func spec() {
        var interactor: PreferencesInteractor!
        var configuration: FBSnapshotsViewer.Configuration!
        var configurationStorage: ConfigurationStorageMock!

        beforeEach {
            configurationStorage = ConfigurationStorageMock()
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcode)
        }

        describe(".setNewDerivedDataFolderPath") {
            context("when current configuration derived data folder type is custom") {
                var newPath: String!

                beforeEach {
                    newPath = "myNewPath"
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: "customPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                    interactor.setNewDerivedDataFolderPath(newPath)
                }

                it("updates configuration") {
                    let currentConfiguration = interactor.currentConfiguration()
                    expect(currentConfiguration.derivedDataFolder.path).to(equal(newPath))
                }
            }

            context("when current configuration derived data folder type is xcode") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = configuration
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                it("asserts") {
                    expect { interactor.setNewDerivedDataFolderPath("myNewPath") }.to(throwAssertion())
                }
            }
        }

        describe(".setNewDerivedDataFolderType") {
            context("when type is not derived data folder type") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = configuration
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                it("asserts") {
                    expect { interactor.setNewDerivedDataFolderType("Foo") }.to(throwAssertion())
                }
            }

            context("when type is equal to current one") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = configuration
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                it("does nothing") {
                    interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcode.rawValue)
                }
            }

            context("when current type is xcode") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = configuration
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                context("when set custom type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.custom.rawValue)
                    }

                    it("updates configuration with custom derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.custom(path: "")))
                    }
                }
            }

            context("when current type is custom") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: "myPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                context("when set custom type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcode.rawValue)
                    }

                    it("updates configuration with custom derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.xcode))
                    }
                }
            }
        }

        describe(".currentConfiguration") {
            beforeEach {
                configurationStorage.loadConfigurationReturnValue = configuration
                interactor = PreferencesInteractor(configurationStorage: configurationStorage)
            }

            it("returns correct configuration") {
                expect(interactor.currentConfiguration()).to(equal(configuration))
            }
        }

        describe(".save") {
            beforeEach {
                configurationStorage.loadConfigurationReturnValue = configuration
                interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                interactor.save()
            }

            it("saves configuration") {
                expect(configurationStorage.saveCalled).to(beTrue())
                expect(configurationStorage.saveReceivedConfiguration).to(equal(configuration))
            }
        }

        describe(".init") {
            context("when configuration storage can load configuration") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.xcode)
                }

                it("initializes new instance") {
                    expect(PreferencesInteractor(configurationStorage: configurationStorage)).toNot(beNil())
                }
            }

            context("when configuration storage can not load configuration") {
                it("asserts") {
                    expect { PreferencesInteractor(configurationStorage: configurationStorage) }.to(throwAssertion())
                }
            }
        }
    }
}
