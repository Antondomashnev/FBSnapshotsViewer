//
//  MenuWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

/// `MenuWireframe` is responsible to build a menu module - app's status bar UI representation
class MenuWireframe {

    weak private var userInterface: MenuController?
    fileprivate var preferencesModule: PreferencesModule?

    // MARK: - Interface

    func instantinateMenu(in statusBar: NSStatusBar, configuration: Configuration) -> MenuUserInterface {
        let menuController = MenuController(statusBar: statusBar)
        let interactor = MenuInteractor(applicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory(),
                                        applicationTestLogFilesListener: ApplicationTestLogFilesListener())
        let presenter = MenuPresenter(configuration: configuration)
        menuController.eventHandler = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        presenter.userInterface = menuController
        presenter.wireframe = self
        userInterface = menuController
        presenter.start()
        return menuController
    }

    func showTestResultsModule(with testResults: [SnapshotTestResult]) {
        guard let presentationView = userInterface?.statusItem.button else {
            return
        }
        let wireframe = TestResultsWireframe()
        wireframe.show(relativeTo: presentationView.bounds, of: presentationView, with: testResults)
    }

    func showPreferencesModule() {
        let wireframe = PreferencesWireframe()
        preferencesModule = wireframe.show(withDelegate: self)
    }
}

extension MenuWireframe: PreferencesModuleDelegate {
    func preferencesModuleWillClose(_ preferencesModule: PreferencesModuleInterface) {
        self.preferencesModule = nil
        let restartAppAlert = NSAlert()
        restartAppAlert.addButton(withTitle: "Ok")
        restartAppAlert.alertStyle = .informational
        restartAppAlert.messageText = "Please restart the FBSnapshotsViewer in order to apply new preferences"
        restartAppAlert.runModal()
    }
}
