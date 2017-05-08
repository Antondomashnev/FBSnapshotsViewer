//
//  MenuPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class MenuPresenter {
    fileprivate let application: Application
    let xcodeDerivedDataFolder: XcodeDerivedDataFolder
    var wireframe: MenuWireframe?
    var interactor: MenuInteractorInput?
    weak var userInterface: MenuUserInterface?

    init(xcodeDerivedDataFolder: XcodeDerivedDataFolder = XcodeDerivedDataFolder.default, application: Application = NSApp) {
        self.application = application
        self.xcodeDerivedDataFolder = xcodeDerivedDataFolder
    }
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

    func showPreferences() {
        wireframe?.showPreferencesModule()
    }

    func quit() {
        application.terminate(self)
    }

    func start() {
        interactor?.startXcodeBuildsListening(xcodeDerivedDataFolder: xcodeDerivedDataFolder)
    }
}

// MARK: - MenuInteractorOutput
extension MenuPresenter: MenuInteractorOutput {
    func didFindNewTestResult(_ testResult: SnapshotTestResult) {
        userInterface?.setNewTestResults(available: true)
    }

    func didFindNewTestLogFile(at path: String) {
        interactor?.startSnapshotTestResultListening(fromLogFileAt: path)
    }
}
