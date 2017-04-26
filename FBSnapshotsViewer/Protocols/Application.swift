//
//  Application.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import AppKit

protocol Application: AutoMockable {
    func terminate(_ sender: Any?)
}

extension NSApplication: Application {}
