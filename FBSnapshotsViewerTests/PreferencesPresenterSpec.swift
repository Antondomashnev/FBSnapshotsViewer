//
//  PreferencesPresenterSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 14.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class PreferencesPresenter_MockPreferencesWireframe: PreferencesWireframe {

}

class PreferencesPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: PreferencesPresenter!
        var interactor: PreferencesInteractorInputMock!
        var wireframe: PreferencesPresenter_MockPreferencesWireframe!
        var userInterface: PreferencesUserInterfaceMock!
        var moduleDelegate: PreferencesModuleDelegateMock!

        beforeEach {
            moduleDelegate = PreferencesModuleDelegateMock()
            userInterface = PreferencesUserInterfaceMock()
            wireframe = PreferencesPresenter_MockPreferencesWireframe()
            interactor = PreferencesInteractorInputMock()
            presenter = PreferencesPresenter()
            presenter.wireframe = wireframe
            presenter.userInterface = userInterface
            presenter.interactor = interactor
            presenter.moduleDelegate = moduleDelegate
        }

        describe(".selectDerivedDataFolderType") {
            beforeEach {
                let configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "myPath"))
                interactor.currentConfigurationReturnValue = configuration
                presenter.select(derivedDataFolderType: "Type")
            }

            it("passes the message to interactor") {
                expect(interactor.setNewDerivedDataFolderType_Called).to(beTrue())
                expect(interactor.setNewDerivedDataFolderType_ReceivedType).to(equal("Type"))
            }

            it("updates user interface") {
                expect(userInterface.showpreferencesDisplayInfoCalled).to(beTrue())
            }
        }

        describe(".updateDerivedDataFolderPath") {
            beforeEach {
                let configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "myPath"))
                interactor.currentConfigurationReturnValue = configuration
                presenter.update(derivedDataFolderPath: "newPath")
            }

            it("passes the message to interactor") {
                expect(interactor.setNewDerivedDataFolderPath_Called).to(beTrue())
                expect(interactor.setNewDerivedDataFolderPath_ReceivedPath).to(equal("newPath"))
            }
        }

        describe(".close") {
            beforeEach {
                presenter.close()
            }

            it("saves") {
                expect(interactor.saveCalled).to(beTrue())
            }

            it("notifies the module delegate that module will close") {
                expect(moduleDelegate.preferencesModuleWillClose_Called).to(beTrue())
            }
        }

        describe(".updateUserInterface") {
            beforeEach {
                let configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "myPath"))
                interactor.currentConfigurationReturnValue = configuration
                presenter.updateUserInterface()
            }

            it("shows preferences display info in user interface") {
                expect(userInterface.showpreferencesDisplayInfoReceivedPreferencesDisplayInfo?.derivedDataFolderPath).to(equal("myPath"))
                expect(userInterface.showpreferencesDisplayInfoReceivedPreferencesDisplayInfo?.derivedDataFolderTypeName).to(equal(DerivedDataFolderType.xcodeCustom.rawValue))
            }
        }
    }
}
