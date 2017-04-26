//
//  List.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import AppKit

protocol List: AutoMockable {
    func reloadData()
}

extension NSCollectionView: List {}
