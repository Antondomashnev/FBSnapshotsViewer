//
//  TestResultsModuleInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol TestResultsModuleInterface: class, AutoMockable {
    func updateUserInterface()
    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo)
    func openInXcode(testResultDisplayInfo: TestResultDisplayInfo)
    func selectDiffMode(_ diffMode: TestResultsDiffMode)
    func accept(_ testResults: [TestResultDisplayInfo])
    func copy(testResultDisplayInfo: TestResultDisplayInfo)
}
