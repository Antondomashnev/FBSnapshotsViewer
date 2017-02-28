//
//  MenuPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class MenuPresenter {
    var wireframe: MenuWireframe?
    var interactor: MenuInteractor?
    weak var userInterface: MenuUserInterface?
}

// MARK: - MenuModuleInterface
extension MenuPresenter: MenuModuleInterface {
    func showTestResults() {
        userInterface?.setNewTestResults(available: false)
    }
    
    func showApplicationMenu() {
        userInterface?.popUpOptionsMenu()
    }
    
    func quit() {
        NSApp.terminate(self)
    }
}

// MARK: - MenuInteractorOutput
extension MenuPresenter: MenuInteractorOutput {
    func didFind(new testResult: TestResult) {
        userInterface?.setNewTestResults(available: true)
    }
}
