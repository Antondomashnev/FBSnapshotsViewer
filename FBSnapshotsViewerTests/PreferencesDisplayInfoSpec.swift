//
//  PreferencesDisplayInfoSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class PreferencesDisplayInfoSpec: QuickSpec {
    override func spec() {
        var displayInfo: PreferencesDisplayInfo!

        describe(".init") {
            it("initializes new instance") {
                displayInfo = PreferencesDisplayInfo(derivedDataFolderPathEditable: true, derivedDataFolderPath: "Foo", derivedDataFolderTypeName: "Bar")
                expect(displayInfo.derivedDataFolderPath).to(equal("Foo"))
                expect(displayInfo.derivedDataFolderTypeName).to(equal("Bar"))
                expect(displayInfo.derivedDataFolderPathEditable).to(beTrue())
                expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode Default", "Xcode Custom", "AppCode"]))
            }
        }

        describe(".initConfiguration") {
            var configuration: FBSnapshotsViewer.Configuration!

            context("when derived data xcodeDefault") {
                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                    displayInfo = PreferencesDisplayInfo(configuration: configuration)
                }

                it("initialized new instance") {
                    expect(displayInfo.derivedDataFolderPath).to(equal(DerivedDataFolder.xcodeDefault.path))
                    expect(displayInfo.derivedDataFolderTypeName).to(equal("Xcode Default"))
                    expect(displayInfo.derivedDataFolderPathEditable).to(beFalse())
                    expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode Default", "Xcode Custom", "AppCode"]))
                }
            }

            context("when derived xcodeCustom") {
                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "Bar"))
                    displayInfo = PreferencesDisplayInfo(configuration: configuration)
                }

                it("initialized new instance") {
                    expect(displayInfo.derivedDataFolderPath).to(equal("Bar"))
                    expect(displayInfo.derivedDataFolderTypeName).to(equal("Xcode Custom"))
                    expect(displayInfo.derivedDataFolderPathEditable).to(beTrue())
                    expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode Default", "Xcode Custom", "AppCode"]))
                }
            }

            context("when derived appcode") {
                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.appcode(path: "Bar"))
                    displayInfo = PreferencesDisplayInfo(configuration: configuration)
                }

                it("initialized new instance") {
                    expect(displayInfo.derivedDataFolderPath).to(equal("Bar"))
                    expect(displayInfo.derivedDataFolderTypeName).to(equal("AppCode"))
                    expect(displayInfo.derivedDataFolderPathEditable).to(beTrue())
                    expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode Default", "Xcode Custom", "AppCode"]))
                }
            }
        }
    }
}
