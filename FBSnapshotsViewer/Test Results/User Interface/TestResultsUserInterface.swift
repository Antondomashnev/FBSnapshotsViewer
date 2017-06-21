//
//  TestResultsUserInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol TestResultsUserInterface: class, AutoMockable {
    func show(displayInfo: TestResultsDisplayInfo)
}
