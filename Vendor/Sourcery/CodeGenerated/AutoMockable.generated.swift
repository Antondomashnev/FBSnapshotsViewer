// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


class ApplicationMock: Application {


    //MARK: - terminate

    var terminateCalled = false
    var terminateReceivedSender: Any?

    func terminate(_ sender: Any?) {

        terminateCalled = true
        terminateReceivedSender = sender
    }
}
class FolderEventsListenerMock: FolderEventsListener {

    var output: FolderEventsListenerOutput?

    //MARK: - init

    var initReceivedArguments: (folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory)?

    required init(folderPath: String, filter: FolderEventFilter?, fileWatcherFactory: FileWatcherFactory) {
        initReceivedArguments = (folderPath: folderPath, filter: filter, fileWatcherFactory: fileWatcherFactory)
    }
    //MARK: - startListening

    var startListeningCalled = false

    func startListening() {

        startListeningCalled = true
    }
    //MARK: - stopListening

    var stopListeningCalled = false

    func stopListening() {

        stopListeningCalled = true
    }
}
class FolderEventsListenerOutputMock: FolderEventsListenerOutput {


    //MARK: - folderEventsListener

    var folderEventsListenerCalled = false
    var folderEventsListenerReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListenerCalled = true
        folderEventsListenerReceivedArguments = (listener: listener, event: event)
    }
}
class ListMock: List {


    //MARK: - reloadData

    var reloadDataCalled = false

    func reloadData() {

        reloadDataCalled = true
    }
}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListeningCalled = false
    var startXcodeBuildsListeningReceivedDerivedDataFolder: DerivedDataFolder?

    func startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder) {

        startXcodeBuildsListeningCalled = true
        startXcodeBuildsListeningReceivedDerivedDataFolder = derivedDataFolder
    }
    //MARK: - startSnapshotTestResultListening

    var startSnapshotTestResultListeningCalled = false
    var startSnapshotTestResultListeningReceivedPath: String?

    func startSnapshotTestResultListening(fromLogFileAt path: String) {

        startSnapshotTestResultListeningCalled = true
        startSnapshotTestResultListeningReceivedPath = path
    }
}
class MenuInteractorOutputMock: MenuInteractorOutput {


    //MARK: - didFindNewTestResult

    var didFindNewTestResultCalled = false
    var didFindNewTestResultReceivedTestResult: SnapshotTestResult?

    func didFindNewTestResult(_ testResult: SnapshotTestResult) {

        didFindNewTestResultCalled = true
        didFindNewTestResultReceivedTestResult = testResult
    }
    //MARK: - didFindNewTestLogFile

    var didFindNewTestLogFileCalled = false
    var didFindNewTestLogFileReceivedPath: String?

    func didFindNewTestLogFile(at path: String) {

        didFindNewTestLogFileCalled = true
        didFindNewTestLogFileReceivedPath = path
    }
}
class MenuModuleInterfaceMock: MenuModuleInterface {


    //MARK: - start

    var startCalled = false

    func start() {

        startCalled = true
    }
    //MARK: - showTestResults

    var showTestResultsCalled = false

    func showTestResults() {

        showTestResultsCalled = true
    }
    //MARK: - showPreferences

    var showPreferencesCalled = false

    func showPreferences() {

        showPreferencesCalled = true
    }
    //MARK: - showApplicationMenu

    var showApplicationMenuCalled = false

    func showApplicationMenu() {

        showApplicationMenuCalled = true
    }
    //MARK: - quit

    var quitCalled = false

    func quit() {

        quitCalled = true
    }
}
class MenuUserInterfaceMock: MenuUserInterface {


    //MARK: - setNewTestResults

    var setNewTestResultsCalled = false
    var setNewTestResultsReceivedAvailable: Bool?

    func setNewTestResults(available: Bool) {

        setNewTestResultsCalled = true
        setNewTestResultsReceivedAvailable = available
    }
    //MARK: - popUpOptionsMenu

    var popUpOptionsMenuCalled = false

    func popUpOptionsMenu() {

        popUpOptionsMenuCalled = true
    }
}
class PreferencesModuleInterfaceMock: PreferencesModuleInterface {


    //MARK: - close

    var closeCalled = false

    func close() {

        closeCalled = true
    }
}
class PreferencesUserInterfaceMock: PreferencesUserInterface {


}
class TestResultCellDelegateMock: TestResultCellDelegate {


    //MARK: - testResultCell

    var testResultCellCalled = false
    var testResultCellReceivedArguments: (cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton)?

    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {

        testResultCellCalled = true
        testResultCellReceivedArguments = (cell: cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButtonClicked)
    }
}
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

    //MARK: - openInKaleidoscope

    var openInKaleidoscopeCalled = false
    var openInKaleidoscopeReceivedTestResult: SnapshotTestResult?

    func openInKaleidoscope(testResult: SnapshotTestResult) {

        openInKaleidoscopeCalled = true
        openInKaleidoscopeReceivedTestResult = testResult
    }
}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
    }
    //MARK: - openInKaleidoscope

    var openInKaleidoscopeCalled = false
    var openInKaleidoscopeReceivedTestResultDisplayInfo: TestResultDisplayInfo?

    func openInKaleidoscope(testResultDisplayInfo: TestResultDisplayInfo) {

        openInKaleidoscopeCalled = true
        openInKaleidoscopeReceivedTestResultDisplayInfo = testResultDisplayInfo
    }
}
class TestResultsUserInterfaceMock: TestResultsUserInterface {


    //MARK: - show

    var showCalled = false
    var showReceivedTestResults: [TestResultDisplayInfo]?

    func show(testResults: [TestResultDisplayInfo]) {

        showCalled = true
        showReceivedTestResults = testResults
    }
}
