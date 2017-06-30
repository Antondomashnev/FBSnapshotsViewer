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
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
        }

        describe(".setNewDerivedDataFolderPath") {
            context("when current configuration derived data folder type is xcodeCustom") {
                var newPath: String!

                beforeEach {
                    newPath = "myNewPath"
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "customPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                    interactor.setNewDerivedDataFolderPath(newPath)
                }

                it("updates configuration") {
                    let currentConfiguration = interactor.currentConfiguration()
                    expect(currentConfiguration.derivedDataFolder.path).to(equal(newPath))
                }
            }

            context("when current configuration derived data folder type is appcode") {
                var newPath: String!

                beforeEach {
                    newPath = "myNewPath"
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.appcode(path: "customPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                    interactor.setNewDerivedDataFolderPath(newPath)
                }

                it("updates configuration") {
                    let currentConfiguration = interactor.currentConfiguration()
                    expect(currentConfiguration.derivedDataFolder.path).to(equal(newPath))
                }
            }

            context("when current configuration derived data folder type is xcodeDefault") {
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
                    interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcodeDefault.rawValue)
                }
            }

            context("when current type is xcodeDefault") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = configuration
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                context("when set xcodeCustom type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcodeCustom.rawValue)
                    }

                    it("updates configuration with xcodeCustom derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.xcodeCustom(path: "")))
                    }
                }

                context("when set appcode type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.appcode.rawValue)
                    }

                    it("updates configuration with appcode derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.appcode(path: "")))
                    }
                }
            }

            context("when current type is xcodeCustom") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "myPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                context("when set xcodeDefault type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcodeDefault.rawValue)
                    }

                    it("updates configuration with xcodeDefault derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.xcodeDefault))
                    }
                }

                context("when set appcode type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.appcode.rawValue)
                    }

                    it("updates configuration with appcode derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.appcode(path: "")))
                    }
                }
            }

            context("when current type is appcode") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.appcode(path: "myPath"))
                    interactor = PreferencesInteractor(configurationStorage: configurationStorage)
                }

                context("when set xcodeDefault type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcodeDefault.rawValue)
                    }

                    it("updates configuration with xcodeDefault derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.xcodeDefault))
                    }
                }

                context("when set xcodeCustom type") {
                    beforeEach {
                        interactor.setNewDerivedDataFolderType(DerivedDataFolderType.xcodeCustom.rawValue)
                    }

                    it("updates configuration with xcodeCustom derived data and empty path") {
                        expect(interactor.currentConfiguration().derivedDataFolder).to(equal(DerivedDataFolder.xcodeCustom(path: "")))
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
                expect(configurationStorage.saveconfigurationCalled).to(beTrue())
                expect(configurationStorage.saveconfigurationReceivedConfiguration).to(equal(configuration))
            }
        }

        describe(".init") {
            context("when configuration storage can load configuration") {
                beforeEach {
                    configurationStorage.loadConfigurationReturnValue = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
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
