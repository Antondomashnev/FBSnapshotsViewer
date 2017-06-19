//
//  TestResultsPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsPresenter {
    fileprivate var selectedDiffMode: TestResultsDiffMode = .mouseOver
    fileprivate let testResultsCollector: TestResultsDisplayInfosCollector
    var interactor: TestResultsInteractorInput?
    var wireframe: TestResultsWireframe?
    weak var userInterface: TestResultsUserInterface?
    
    init(testResultsCollector: TestResultsDisplayInfosCollector = TestResultsDisplayInfosCollector()) {
        self.testResultsCollector = testResultsCollector
    }
}

extension TestResultsPresenter: TestResultsModuleInterface {
    func updateUserInterface() {
        guard let testResults = interactor?.testResults, !testResults.isEmpty  else {
            return
        }
        let testResultsDisplayInfo = TestResultsDisplayInfo(sectionInfos: testResultsCollector.collect(testResults: testResults), testResultsDiffMode: .mouseOver)
        userInterface?.show(displayInfo: testResultsDisplayInfo)
    }

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {
        interactor?.openInKaleidoscope(testResult: testResultDisplayInfo.testResult)
    }
}
