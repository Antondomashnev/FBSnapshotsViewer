//
//  TestResultsPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsPresenter {
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
        userInterface?.show(testResults: testResultsCollector.collect(testResults: testResults))
    }

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {
        interactor?.openInKaleidoscope(testResult: testResultDisplayInfo.testResult)
    }
}
