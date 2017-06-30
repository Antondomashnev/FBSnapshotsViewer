//
//  PreferencesWireframeSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class PreferencesWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: PreferencesWireframe!
        var moduleDelegate: PreferencesModuleDelegateMock!
        var configurationStorage: ConfigurationStorageMock!

        beforeEach {
            configurationStorage = ConfigurationStorageMock()
            moduleDelegate = PreferencesModuleDelegateMock()
            wireframe = PreferencesWireframe()
        }

        describe(".show") {
            beforeEach {
                configurationStorage.loadConfiguration_ReturnValue = Configuration.default()
            }

            it("returns preferences module") {
                expect(wireframe.show(withDelegate: moduleDelegate, configurationStorage: configurationStorage)).toNot(beNil())
            }
        }
    }
}
