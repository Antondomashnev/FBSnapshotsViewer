//
//  ImageCache.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 01.07.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol ImageCache: AutoMockable {
    func invalidate()
}
