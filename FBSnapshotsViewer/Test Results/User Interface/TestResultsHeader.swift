//
//  TestResultsHeader.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class TestResultsHeader: NSObject, NSCollectionViewSectionHeaderView {
    var identifier: String?
    
    @IBOutlet private weak var contextLabel: NSTextField!
    @IBOutlet private weak var dateLabel: NSTextField!
    
    // MARK: - Interface
}
