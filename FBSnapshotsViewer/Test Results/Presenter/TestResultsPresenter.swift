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
        let testResultsDisplayInfo = TestResultsDisplayInfo(sectionInfos: testResultsCollector.collect(testResults: testResults), testResultsDiffMode: selectedDiffMode)
        userInterface?.show(displayInfo: testResultsDisplayInfo)
    }

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {
        interactor?.openInKaleidoscope(testResult: testResultDisplayInfo.testResult)
    }
    
    func openInXcode(testResultDisplayInfo: TestResultDisplayInfo) {
        interactor?.openInXcode(testResult: testResultDisplayInfo.testResult)
    }
    
    func selectDiffMode(_ diffMode: TestResultsDiffMode) {
        selectedDiffMode = diffMode
        updateUserInterface()
    }
    
    func accept(_ testResults: [TestResultDisplayInfo]) {
        for testResultInfo in testResults {
            interactor?.accept(testResult: testResultInfo.testResult)
        }
        updateUserInterface()
    }
    
    func copy(testResultDisplayInfo: TestResultDisplayInfo) {
        interactor?.copy(testResult: testResultDisplayInfo.testResult)
    }
}

extension TestResultsPresenter: TestResultsInteractorOutput {
    func didFailToAccept(testResult: SnapshotTestResult, with error: Error) {
        let failToAcceptAlert = NSAlert()
        failToAcceptAlert.addButton(withTitle: "Ok")
        failToAcceptAlert.alertStyle = .critical
        failToAcceptAlert.messageText = "Ops, accept can not be done. \(error.localizedDescription). Please report an issue https://github.com/Antondomashnev/FBSnapshotsViewer/issues/new"
        failToAcceptAlert.runModal()
    }
}
