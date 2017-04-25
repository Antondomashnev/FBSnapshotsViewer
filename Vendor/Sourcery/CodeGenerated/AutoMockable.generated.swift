// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Cocoa

class FolderEventsListenerOutputMock: FolderEventsListenerOutput {


    //MARK: - folderEventsListener

    var folderEventsListenerCalled = false
    var folderEventsListenerReceivedArguments: (listener: FolderEventsListener, event: FolderEvent)?

    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {

        folderEventsListenerCalled = true
        folderEventsListenerReceivedArguments = (listener: listener, event: event)
    }

}
class MenuInteractorInputMock: MenuInteractorInput {

    var foundTestResults: [SnapshotTestResult] = []

    //MARK: - startXcodeBuildsListening

    var startXcodeBuildsListeningCalled = false
    var startXcodeBuildsListeningReceivedXcodeDerivedDataFolder: XcodeDerivedDataFolder?

    func startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder) {

        startXcodeBuildsListeningCalled = true
        startXcodeBuildsListeningReceivedXcodeDerivedDataFolder = xcodeDerivedDataFolder
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
class TestResultsInteractorInputMock: TestResultsInteractorInput {

    var testResults: [SnapshotTestResult] = []

}
class TestResultsModuleInterfaceMock: TestResultsModuleInterface {


    //MARK: - updateUserInterface

    var updateUserInterfaceCalled = false

    func updateUserInterface() {

        updateUserInterfaceCalled = true
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
