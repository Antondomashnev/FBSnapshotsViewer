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
}

extension PreferencesPresenter: PreferencesModuleInterface {
    // MARK: - PreferencesModuleInterface

    func close() {
        moduleDelegate?.preferencesModuleWillClose(self)
    }
}
