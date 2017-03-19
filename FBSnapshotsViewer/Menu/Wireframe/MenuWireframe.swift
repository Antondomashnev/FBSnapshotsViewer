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

    // MARK: - Interface

    func instantinateMenu(in statusBar: NSStatusBar) -> MenuUserInterface {
        let menuController = MenuController(statusBar: statusBar)
        let interactor = MenuInteractor(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener(),
                                        applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder(),
                                        applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener())
        let presenter = MenuPresenter()
        menuController.eventHandler = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        presenter.userInterface = menuController
        presenter.wireframe = self
        userInterface = menuController
        return menuController
    }

    func showTestResultsModule(with testResults: [TestResult]) {
        guard let presentationView = userInterface?.statusItem.button else {
            return
        }
        let wireframe = TestResultsWireframe()
        wireframe.show(relativeTo: presentationView.bounds, of: presentationView, with: testResults)
    }
}
