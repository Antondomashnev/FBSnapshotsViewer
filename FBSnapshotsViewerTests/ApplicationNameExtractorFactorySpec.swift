//
//  ApplicationNameExtractorFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationNameExtractorFactorySpec: QuickSpec {
    override func spec() {
        var factory: ApplicationNameExtractorFactory!
        var configuration: FBSnapshotsViewer.Configuration!

        beforeEach {
            factory = ApplicationNameExtractorFactory()
        }

        describe(".applicationNameExtractor") {
            context("for xcode derived data configuration") {
                beforeEach {
                    configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "lalala"))
                }

                it("returns xcode application name extractror") {
                    let extractor = factory.applicationNameExtractor(for: configuration)
                    expect(extractor is XcodeApplicationNameExtractor).to(beTrue())
                }
            }

            context("for xcode default derived data configuration") {
                beforeEach {
                    configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                }

                it("returns xcode application name extractror") {
                    let extractor = factory.applicationNameExtractor(for: configuration)
                    expect(extractor is XcodeApplicationNameExtractor).to(beTrue())
                }
            }

            context("for appcode derived data configuration") {
                beforeEach {
                    configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.appcode(path: "foo/bar"))
                }

                it("returns appcode application name extractror") {
                    let extractor = factory.applicationNameExtractor(for: configuration)
                    expect(extractor is AppCodeApplicationNameExtractor).to(beTrue())
                }
            }
        }
    }
}
