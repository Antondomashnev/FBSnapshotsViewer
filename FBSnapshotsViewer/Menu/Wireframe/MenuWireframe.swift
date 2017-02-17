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
        let interactor = MenuInteractor(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener(), folderEventsListenerFactory: FolderEventsListenerFactory())
        let userInterface = MenuController(statusBar: statusBar)
        userInterface.interactor = interactor
        return userInterface
    }
}
