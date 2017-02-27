//
//  MenuWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

/// `MenuWireframe` is responsible to build a menu module - app's status bar UI representation
final class MenuWireframe {
    
    func instantinateMenu(in statusBar: NSStatusBar) -> MenuUserInterface {
        let interactor = MenuInteractor(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener(),
                                        applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder(),
                                        applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener())
        let presenter = MenuPresenter()
        let userInterface = MenuController(statusBar: statusBar)
        userInterface.eventHandler = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        presenter.userInterface = userInterface
        presenter.wireframe = self
        return userInterface
    }
}
