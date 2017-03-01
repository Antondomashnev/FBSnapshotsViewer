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
        guard let testResults = interactor?.foundTestResults, !testResults.isEmpty else {
            return
        }
        
        userInterface?.setNewTestResults(available: false)
        wireframe?.showTestResultsModule(with: testResults)
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
