//
//  PreferencesControllerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class PreferencesControllerSpec: QuickSpec {
    override func spec() {
        var eventHandler: PreferencesModuleInterfaceMock!
        var controller: PreferencesController!

        beforeEach {
            eventHandler = PreferencesModuleInterfaceMock()
            controller = StoryboardScene.Main.instantiatePreferencesWindowController().contentViewController as? PreferencesController
            controller.eventHandler = eventHandler
        }

        describe(".viewWillAppear") {
            beforeEach {
                controller.viewWillAppear()
            }

            it("updates user interface") {
                expect(eventHandler.updateUserInterfaceCalled).to(beTrue())
            }
        }

        describe(".viewDidDisappear") {
            beforeEach {
                controller.viewDidDisappear()
            }

            it("closes") {
                expect(eventHandler.closeCalled).to(beTrue())
            }
        }

        describe(".showPreferencesDisplayInfo") {
            var preferencesDisplayInfo: PreferencesDisplayInfo!

            beforeEach {
                preferencesDisplayInfo = PreferencesDisplayInfo(derivedDataFolderPathEditable: true, derivedDataFolderPath: "myPath", derivedDataFolderTypeName: "Xcode Custom")
                controller.show(preferencesDisplayInfo: preferencesDisplayInfo)
            }

            it("updates UI") {
                expect(controller.derivedDataPathLabel.stringValue).to(equal("myPath"))
                expect(controller.derivedDataPathTextField.isEnabled).to(beTrue())
                expect(controller.derivedDataPathTextField.stringValue).to(equal("myPath"))
                expect(controller.derivedDataTypePopUpButton.itemTitles).to(equal(preferencesDisplayInfo.derivedDataFolderTypeNames))
                expect(controller.derivedDataTypePopUpButton.titleOfSelectedItem).to(equal("Xcode Custom"))
            }
        }

        describe(".popUpValueChanged") {
            beforeEach {
                controller.derivedDataTypePopUpButton.addItem(withTitle: "Bar")
                controller.derivedDataTypePopUpButton.selectItem(withTitle: "Bar")
                controller.popUpValueChanged(controller.derivedDataTypePopUpButton)
            }

            it("updates derived data type") {
                expect(eventHandler.selectReceivedDerivedDataFolderType).to(equal("Bar"))
                expect(eventHandler.selectCalled).to(beTrue())
            }
        }

        describe(".derivedDataPathTextFieldDidChange") {
            beforeEach {
                controller.derivedDataPathTextField.stringValue = "NewPath"
                controller.derivedDataPathTextFieldDidChange(notification: Notification(name: Notification.Name("Foo")))
            }

            it("updated dervied data path label") {
                expect(controller.derivedDataPathLabel.stringValue).to(equal("NewPath"))
            }

            it("updates derived data path") {
                expect(eventHandler.updateReceivedDerivedDataFolderPath).to(equal("NewPath"))
                expect(eventHandler.updateCalled).to(beTrue())
            }
        }
    }
}
