//
//  AppleInterfaceModeSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class AppleInterfaceModeSpec: QuickSpec {
    override func spec() {
        var settings: UserDefaults!

        beforeEach {
            settings = UserDefaults()
        }

        afterEach {
            let keys = settings.dictionaryRepresentation().keys
            for key in keys {
                settings.removeObject(forKey: key)
            }
        }

        describe("AppleInterfaceMode") {
            context("when settings contains AppleInterfaceStyle key") {
                beforeEach {
                    settings.set("Dark", forKey: "AppleInterfaceStyle")
                }

                it("is dark") {
                    expect(AppleInterfaceMode(settings: settings)).to(equal(AppleInterfaceMode.dark))
                }
            }

            context("when settings doesnt contain AppleInterfaceStyle key") {
                it("is light") {
                    expect(AppleInterfaceMode(settings: settings)).to(equal(AppleInterfaceMode.light))
                }
            }
        }
    }
}
