//
//  MenuInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import clibc
import SPMLibc
//import SPMUtility
import XCParseCore
import xcparse

class MenuInteractor {
    weak var output: MenuInteractorOutput?

    /// Currently found test results
    /// Note: it resets every notification about new application test run
    fileprivate var currentlyFoundTestResults: [SnapshotTestResult] = []

    /// Dictionary with key:pair - application log path: application snapshot test result listener
    fileprivate typealias ApplicationLogPath = String
    fileprivate var applicationSnapshotTestResultListeners: [ApplicationLogPath: ApplicationSnapshotTestResultListener] = [:]

    /// Instance of aplication snapshot test listener factory
    fileprivate let applicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory

    /// Instance of applications test log files listener
    fileprivate let applicationTestLogFilesListener: ApplicationTestLogFilesListener
    
    /// Instance of applications configuration
    fileprivate let configuration: Configuration

    init(applicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory,
         applicationTestLogFilesListener: ApplicationTestLogFilesListener,
         configuration: Configuration) {
        self.applicationTestLogFilesListener = applicationTestLogFilesListener
        self.applicationSnapshotTestResultListenerFactory = applicationSnapshotTestResultListenerFactory
        self.configuration = configuration
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    var foundTestResults: [SnapshotTestResult] {
        return currentlyFoundTestResults
    }

    func startSnapshotTestResultListening(fromLogFileAt path: String) {
        if applicationSnapshotTestResultListeners[path] != nil {
            return
        }
      let pat = path.replacingOccurrences(of: "/Info.plist", with: "")
      var xcresult = XCResult(path: pat)
      
      let parser = XCPParser()
      try? parser.extractAttachments(xcresultPath: pat,
                                     destination: xcresult.path)
      
      guard let invocationRecord = xcresult.invocationRecord else {
        return
      }
      
      let actions = invocationRecord.actions.filter { $0.actionResult.testsRef != nil }
      
      for action in actions {
        guard let testRef = action.actionResult.testsRef else {
          continue
        }
        
        guard let testPlanRunSummaries: ActionTestPlanRunSummaries = testRef.modelFromReference(withXCResult: xcresult) else {
            xcresult.console.writeMessage("Error: Unhandled test reference type \(String(describing: testRef.targetType?.getType()))", to: .error)
            continue
        }

        for testPlanRun in testPlanRunSummaries.summaries {
          let testableSummaries = testPlanRun.testableSummaries
          for testableSummary in testableSummaries {
            let testableSummariesToTestActivity = testableSummary.flattenedTestSummaryMap(withXCResult: xcresult)
            
            let results = testableSummariesToTestActivity.flatMap { (summary, summaries) -> [SnapshotTestResult] in
              let className = summary.identifier?.split(separator: "/").first ?? ""
              let res = summaries.map { childSummary -> SnapshotTestResult in
                let info = SnapshotTestInformation(testClassName: String(className),
                                                   testName: childSummary.title,
                                                   testFilePath: childSummary.title,
                                                   testLineNumber: 0)
                let build = Build(date: Date(),
                                  applicationName: "",
                                  fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: configuration.referenceImagesFolder)])
                
                let failed = "\(xcresult.path)/" + (childSummary.attachments[1].filename ?? "")
                let diff = "\(xcresult.path)/" + (childSummary.attachments[2].filename ?? "")
                let ref = "\(xcresult.path)/" + (childSummary.attachments[0].filename ?? "")
                return SnapshotTestResult.failed(testInformation: info,
                                                 referenceImagePath: ref,
                                                 diffImagePath: diff,
                                                 failedImagePath: failed,
                                                 build: build)
              }
              
              return res
            }
            
            self.currentlyFoundTestResults.insert(contentsOf: results, at: 0)
            if let first = results.first {
              self.output?.didFindNewTestResult(first)
            }
          }
        }
      }
      
        let applicationSnapshotTestResultListener = applicationSnapshotTestResultListenerFactory.applicationSnapshotTestResultListener(forLogFileAt: path, configuration: configuration)
        applicationSnapshotTestResultListener.startListening { [weak self] testResult in
            self?.currentlyFoundTestResults.insert(testResult, at: 0)
            self?.output?.didFindNewTestResult(testResult)
        }
        applicationSnapshotTestResultListeners[path] = applicationSnapshotTestResultListener
    }

    func startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder) {
        applicationTestLogFilesListener.stopListening()
        applicationTestLogFilesListener.listen(derivedDataFolder: derivedDataFolder) { [weak self] path in
            self?.output?.didFindNewTestLogFile(at: path)
        }
    }
}
