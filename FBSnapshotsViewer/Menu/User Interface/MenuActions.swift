//
//  MenuActions.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuActions: AutoMockable {
    func handleIconMouseEvent(_ event: NSEvent)
}
