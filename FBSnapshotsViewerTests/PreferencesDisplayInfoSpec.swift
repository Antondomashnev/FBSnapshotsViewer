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
                expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode", "Custom"]))
            }
        }

        describe(".initConfiguration") {
            var configuration: FBSnapshotsViewer.Configuration!

            context("when derived data xcode") {
                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcode)
                    displayInfo = PreferencesDisplayInfo(configuration: configuration)
                }

                it("initialized new instance") {
                    expect(displayInfo.derivedDataFolderPath).to(equal(DerivedDataFolder.xcode.path))
                    expect(displayInfo.derivedDataFolderTypeName).to(equal("Xcode"))
                    expect(displayInfo.derivedDataFolderPathEditable).to(beFalse())
                    expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode", "Custom"]))
                }
            }

            context("when derived custom") {
                beforeEach {
                    configuration = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: "Bar"))
                    displayInfo = PreferencesDisplayInfo(configuration: configuration)
                }

                it("initialized new instance") {
                    expect(displayInfo.derivedDataFolderPath).to(equal("Bar"))
                    expect(displayInfo.derivedDataFolderTypeName).to(equal("Custom"))
                    expect(displayInfo.derivedDataFolderPathEditable).to(beTrue())
                    expect(displayInfo.derivedDataFolderTypeNames).to(equal(["Xcode", "Custom"]))
                }
            }
        }
    }
}
