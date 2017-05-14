//
//  ConfigurationSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class ConfigurationSpec: QuickSpec {
    override func spec() {
        var configuration: FBSnapshotsViewer.Configuration!

        describe(".default") {
            it("returns xcode configuration") {
                expect(Configuration.default()).to(equal(Configuration.init(derivedDataFolder: DerivedDataFolder.xcode)))
            }
        }

        describe(".init") {
            it("initializes new configuration") {
                let derivedDataFolder = DerivedDataFolder.custom(path: "Foo")
                expect(Configuration(derivedDataFolder: derivedDataFolder).derivedDataFolder).to(equal(derivedDataFolder))
            }
        }

        describe(".decoding") {
            it("archives and unarchives the configuration") {
                configuration = Configuration(derivedDataFolder: DerivedDataFolder.custom(path: "Foo"))
                let data: Data! = NSKeyedArchiver.archivedData(withRootObject: configuration)
                let unarchivedConfiguration = NSKeyedUnarchiver.unarchiveObject(with: data)
                expect(configuration.isEqual(unarchivedConfiguration)).to(beTrue())
            }
        }

        describe(".isEqual") {
            context("when object is not configuration") {
                it("returns false") {
                    expect(Configuration.default().isEqual(NSObject())).toNot(beTrue())
                }
            }

            context("when object is configuration") {
                it("compares derived data folder") {
                    expect(Configuration(derivedDataFolder: DerivedDataFolder.xcode)).to(equal(Configuration(derivedDataFolder: DerivedDataFolder.xcode)))
                    expect(Configuration(derivedDataFolder: DerivedDataFolder.xcode)).toNot(equal(Configuration(derivedDataFolder: DerivedDataFolder.custom(path: "Foo"))))
                }
            }
        }
    }
}
