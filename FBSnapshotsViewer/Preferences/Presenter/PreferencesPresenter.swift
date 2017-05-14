//
//  PreferencesPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 07.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class PreferencesPresenter {
    weak var userInterface: PreferencesUserInterface?
    weak var moduleDelegate: PreferencesModuleDelegate?
    var wireframe: PreferencesWireframe!
    var interactor: PreferencesInteractorInput!
}

extension PreferencesPresenter: PreferencesModuleInterface {
    // MARK: - PreferencesModuleInterface

    func updateUserInterface() {
        let preferencesDisplayInfo = PreferencesDisplayInfo(configuration: interactor.currentConfiguration())
        userInterface?.show(preferencesDisplayInfo: preferencesDisplayInfo)
    }

    func select(derivedDataFolderType: String) {
        interactor.setNewDerivedDataFolderType(derivedDataFolderType)
        updateUserInterface()
    }

    func update(derivedDataFolderPath: String) {
        interactor.setNewDerivedDataFolderPath(derivedDataFolderPath)
    }

    func close() {
        interactor.save()
        moduleDelegate?.preferencesModuleWillClose(self)
    }
}
